#pragma rtGlobals=1		// Use modern global access method.

function rundbEditor()
	sets("dbEdit:tableMenu", gets("dbEdit:tableMenu", "cell;acquisition;physacq;imagingacq"))
	sets("dbEdit:where", gets("dbEdit:where", ""))
	
	make/o/t/n=(0, 0) root:dbedit:lbWave

	make/b/u/o/n=(0, 0, 2) root:dbedit:lbSelWave
	
	UpdateListBoxWaves()
	execute "dbEditor()"
end

function /s getPKbyTable(table)
	string table
	string pk=""
	
	
	if(cmpstr(table, "cell")==0)
		pk="cell_id"
	endif
	
	if(cmpstr(table, "acquisition")==0)
		pk="acq_id"
	endif

	if(cmpstr(table, "physacq")==0)
		pk="physacq_id"
	endif

	if(cmpstr(table, "imagingacq")==0)
		pk="imagingacq_id"
	endif

	return pk
end

function UpdateListBoxWaves()
	string where=gets("dbedit:where", "")
	execute "controlinfo popup_table"
	string table=gets("s_value", "cell")
	
	string pk=getPKbyTable(table)
	sets("dbEdit:currTable", table)
	sets("dbEdit:currPK", pk)
	
	string sql="SELECT * FROM "+table
	if(strlen(where)>0)
		sql=sql+" WHERE "+where
	endif

	sql=sql+" ORDER BY "+pk

	//killcontrol dbe_lb
	
	print sql
	
	Pqxop/q=sql

	variable ncols=numpnts(PQ_fnames)
	variable nrows=getNtuples()
	
	//make/o/t/n=(nrows, ncols) root:dbedit:lbWave
	redimension/n=(nrows, ncols) root:dbedit:lbWave
	
	wave /t lbwave=root:dbedit:lbWave

	//make/b/u/o/n=(nrows, ncols, 2) root:dbedit:lbSelWave
	redimension/n=(nrows, ncols, 2) root:dbedit:lbSelWave

	wave selwave=root:dbedit:lbSelWave
	variable col
	wave /t PQ_fnames
	
	for(col=0;col<ncols;col+=1)
		wave /t thecol=$"PQf_"+PQ_fnames[col]
		//print "PQf_"+PQ_fnames[col]
		lbwave[][col]=thecol[p]
		if(cmpstr(PQ_fnames[col], pk)==0)
			set("dbEdit:pk_col_num", col)
		else
			selwave[][col]=0x06
		endif
		setdimlabel 1, col, $PQ_fnames[col], lbwave
	endfor

	PQclearres()
end

Function BtnGoProc(ctrlName) : ButtonControl
	String ctrlName

	updatelistboxwaves()
End

Window dbEditor() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(683,135,1267,519)
	PopupMenu popup_table,pos={7,2},size={85,21},title="Table"
	PopupMenu popup_table,mode=1,popvalue="cell",value= #"root:dbedit:tablemenu"
	SetVariable setvar0,pos={135,5},size={406,16},title="WHERE"
	SetVariable setvar0,value= root:dbEdit:where
	Button btnGo,pos={547,4},size={26,18},proc=BtnGoProc,title="Go"
	ListBox lb,pos={9,30},size={567,345},proc=DBedit_ListBoxProc
	ListBox lb,listWave=root:dbEdit:lbWave,selWave=root:dbEdit:lbSelWave,mode= 2
	ListBox lb,selRow= 0,widths={46,66,81,65,56,77,101,75,91,91},userColumnResize= 1
EndMacro

Function DBedit_ListBoxProc(ctrlName,row,col,event) : ListBoxControl
	String ctrlName
	Variable row
	Variable col
	Variable event	//1=mouse down, 2=up, 3=dbl click, 4=cell select with mouse or keys
					//5=cell select with shift key, 6=begin edit, 7=end
					
					//GetDimLabel(waveName, dimNumber, dimIndex )
		

	if(event ==7)	// bit 0, value set
		//gets("dbEdit:currTable", table)
		//gets("dbEdit:currPK", pk)
		string sql
		wave/t lbwave =root:dbedit:lbwave
		//print "where ", gets("dbEdit:currPK", ""), "=", lbwave[row][get("dbEdit:pk_col_num", 0)], GetDimLabel(lbwave, 1, col ) , "=", lbwave[row][col]
		sql="UPDATE "+gets("dbEdit:currTable", "nosuchtable")+" SET "+GetDimLabel(lbwave, 1, col )
		sql=sql+"='"+lbwave[row][col]+"' WHERE "+gets("dbEdit:currPK", "nosuchprimarykey")+"='"+lbwave[row][get("dbEdit:pk_col_num", 0)]+"'"
		print SQL
		pqxop/q=sql
		pqclearres()
	endif

	return 0
End
