#pragma rtGlobals=1		// Use modern global access method.

function/s textWaveToList(tw)
	wave/t tw
	string list=""
	variable i
	
	for(i=0;i<numpnts(tw);i+=1)
		list=list+tw[i]+";"
		//sprintf list, "%s;%s;" maps[i]	
	endfor
	
	list=list[0,strlen(list)-2]
	return list 
end

function runCellBrowser()
	string sql
	string initials=gets("userinitials", "TN")
	sets("userInitials", initials)
		
	
	string typefilter=gets("typefilter", "")
	sets("typefilter", typefilter)
	
	string namefilter=gets("namefilter", "")
	sets("namefilter", namefilter)
	
	//ideally check if we are connected
	
	//get profiles
	
	CBupdateProfileList(initials)
	
	CBupdateCelllist("userinitials~'"+initials+"' AND cellname~'"+namefilter+"' AND celltype~'"+typefilter+"'")
	
	wave/t cell_list
	if(waveexists(cell_list))
		CBviewCell(cell_list[0][1])
	else
		CBviewCell("1")
	endif
	execute "cellBrowser()"

end



function CBupdateProfileList(initials)
	string initials
	string sql
	
	sql="SELECT profile_name FROM acqb_profile WHERE userinitials='"+initials+"'"
	//print sql
	PQxop/Q=sql
	
	if(waveexists(PQf_profile_name))
		duplicate /o PQf_profile_name profiles
	else
		print "no profiles found"
		return 0
	endif
	
	sets("profileList", textwavetolist(profiles)) 
end

function CBupdateCellList(where)
	string where
	variable ncells, i
	string sql
	string initials=gets("userinitials", "TN")
	
	if(strlen(where)==0)
		sql="SELECT cellname, cell_id, celltype FROM cell ORDER BY cell_id"
	else
		sql="SELECT cellname, cell_id, celltype FROM cell WHERE "+where+" ORDER BY cell_id"
	endif

	//print sql 
	PQxop/Q=SQL

	if(!waveexists(PQf_cellname))
		ncells=0
	else
		ncells=numpnts(PQf_cellname)
	endif
	
	make/o/t/n=(ncells, 3) cell_list
	Make/B/U/O/N=(ncells,3,2) selwave
	
	wave/t PQf_cellname
	wave/t PQf_cell_id
	wave/t PQf_celltype
	
	
	for(i=0;i<ncells;i+=1)
		cell_list[i][0]=PQf_cellname[i]
		cell_list[i][1]=PQf_cell_id[i]
		cell_list[i][2]=PQf_celltype[i]	
	endfor
	
	setdimlabel 1, 0, Name, cell_list
	setdimlabel 1, 1, ID, cell_list
	setdimlabel 1, 2, Type, cell_list
	
end

Window cellBrowser() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(205,168,895,455)
	ListBox lb,pos={17,37},size={236,145},proc=CellBrowserListBoxProc
	ListBox lb,listWave=root:cell_list,selWave=root:selwave,mode= 2,selRow= 0
	ListBox lb,widths={71,41,107},userColumnResize= 1
	SetVariable setinitials,pos={15,8},size={57,16},proc=FilterBtnProc,title="User"
	SetVariable setinitials,value= userinitials
	PopupMenu popup0,pos={89,196},size={129,21},title="Profile"
	PopupMenu popup0,mode=1,popvalue="mini analysis",value= #"profilelist"
	Button btnLoad,pos={15,196},size={66,21},proc=BtnLoadCell,title="Load cell"
	ListBox lb2,pos={273,8},size={412,256},listWave=root:mycomments
	ListBox lb2,selWave=root:commentsel
	ValDisplay valdisp0,pos={18,229},size={61,15},title="#acqs"
	ValDisplay valdisp0,limits={0,0,0},barmisc={0,1000},value= #"numberofacqs"
	SetVariable setvar0,pos={18,251},size={232,16},title="cycles",value= usedCycles
	SetVariable settype,pos={81,8},size={80,16},proc=FilterBtnProc,title="Type"
	SetVariable settype,value= typefilter
	SetVariable setname,pos={167,8},size={88,16},proc=FilterBtnProc,title="Name"
	SetVariable setname,value= namefilter
EndMacro

Function FilterBtnProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	CBupdateProfileList(gets("userinitials", "TN"))
	
	CBupdateCelllist("userinitials~'"+gets("userinitials", "TN")+"' AND cellname~'"+gets("namefilter", "")+"' AND celltype~'"+gets("typefilter", "")+"'")
	
	
End

Function CellBrowserListBoxProc(ctrlName,row,col,event) : ListBoxControl
	String ctrlName
	Variable row
	Variable col 
	Variable event	//1=mouse down, 2=up, 3=dbl click, 4=cell select with mouse or keys
					//5=cell select with shift key, 6=begin edit, 7=end

	if(event %& 0x4)	// bit 0, value set
		wave /t cell_list
		//print "view cell with ID ", cell_list[row][1]
		cbviewcell(cell_list[row][1])
	endif
	return 0
End

function CBviewCell(ID)
	string ID
	
	
	PQXop/Q="SELECT \"comment\" from cellComments WHERE section='1' AND cell_id="+id
	wave /t PQf_comment
	if(waveexists(PQf_comment))
		execute "duplicate /o PQf_comment mycomments"
	else 
		execute "make/o/t/n=(10,1) mycomments"
	endif
	
	wave /t mycomments
	
	Make/B/U/O/N=(numpnts(mycomments),1,2) commentsel
	
	pqclearres()
	
	PQXop/Q="SELECT COUNT(acq_id) FROM acquisition WHERE cell_id="+id
	
	wave/t PQf_count
	if(waveexists(PQf_count))
		set("numberOfAcqs", str2num(PQf_count[0]))
	else
		set("numberOfAcqs", 0)
	endif
	pqclearres()
	
	PQXop/Q="SELECT DISTINCT cyclename FROM acquisition WHERE cell_id="+id
	
	if(waveexists(PQf_cyclename))
		sets("usedCycles", textwavetolist(PQf_cyclename))
	else
		sets("usedCycles", "")
	endif
	
end

Function BtnLoadCell(ctrlName) : ButtonControl
	String ctrlName
	execute "controlinfo lb"
	variable row=get("root:v_value", 0)
	wave/t cell_list
	//print "load cell with ID ", cell_list[row][1]
	//first load profile
	execute "controlinfo popup0"
	string profile=gets("root:s_value", "")
	loaduserprofile(profile)
	loadcellfromDB(str2num(cell_list[row][1]))
	execute "acqbmainpanel()"
	DoWindow/K cellBrowser
End

function NB2Comment()
	execute "controlinfo lb"
	variable row=get("root:v_value", 0)
	wave/t cell_list
	string cell_id= cell_list[row][1]
	string sql

	variable fp
	open/R fp as ""
	if (fp == 0)
		return -1						// User canceled
	endif
	
	string line
	
	do
		FReadLine fp, line
		if(strlen(line)>0)
			sql="INSERT INTO cellcomments(cell_id, comment, section) values ('"+cell_id+"', '"+line[0,strlen(line)-2]+"', '1')"
			//print sql
			PQxop/Q="INSERT INTO cellcomments(cell_id, comment, section) values ('"+cell_id+"', '"+line+"', '1')"
		endif
	while (strlen(line)>0)
end


