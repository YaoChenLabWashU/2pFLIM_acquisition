#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------
// browser, current acq stuff.
//-------------------------------

Menu "acqBrowser"
	"Connect", PQxop/C="host=yqr5-a5-0012 dbname=labdata user=postgres password=ntcfop99"
	"Disconnect", PQxop/D
	"cellBrowser", runCellBrowser()
	"dbEditor", rundbEditor()
	"-"
	"List user profiles", listuserprofiles("")
	"Load Profile", loadprofile_interactive()
	"-"
	"List cells", listcellsindb("")
	"Load cell", loadcell_interactive()
	"Unload cell", killcell(0)
	"Main Panel", acqbmainpanel()
End

function loadcell_interactive()
	Dowindow celltable

	if(!v_flag) //no such window
		variable cell_id
		prompt cell_id, "Cell ID"
		doprompt "Enter ID of cell to load", cell_id
		if(!v_flag)
			loadcellfromdb(cell_id)
		endif
	else
		string info=TableInfo("celltable", -2)
		variable row= numberbykey("SELECTION", info)
		wave /t PQf_cell_id
		if(waveexists(PQf_cell_id))
			//print "loading profile", PQf_cell_id[row]
			loadcellfromDB(str2num(PQf_cell_id[row]))
		endif
	endif
end

function loadprofile_interactive()
	Dowindow profiletable

	if(!v_flag) //no such window
	else
		string info=TableInfo("profiletable", -2)
		variable row= numberbykey("SELECTION", info)
		wave /t PQf_profile_name
		if(waveexists(PQf_profile_name))
			//print "loading profile", PQf_profile_name[row]
			loadUserProfile(PQf_profile_name[row])
		endif
	endif
end

function listUserProfiles(initials)
	string initials
	string sql

	if(strlen(initials)==0)
		sql="SELECT profile_name, userinitials FROM acqb_profile"
	else
		sql="SELECT profile_name FROM acqb_profile WHERE userinitials='"+initials+"'"
	endif
	
	DoWindow /K profileTable	
	
	edit /k=1/N=profileTable as "List of profiles"
	ModifyTable width(Point)=0
	
	PQtable(sql)
	
end

function listCellsInDB(where)
	string where
	string sql
	
	if(strlen(where)==0)
		sql="SELECT * FROM cell"
	else
		sql="SELECT * FROM cell WHERE "+where
	endif
	
	DoWindow /K cellTable	
	
	edit /k=1/N=cellTable as "List of cells"
	ModifyTable width(Point)=0
	
	PQtable(sql)
end

function storeUserProfile(name, user)
	string name
	string user
	
	string code=""
	string long_code=""
	string sql
	
	variable i
	
	wave /t tables=root:acqBrowser:valMapTable
	wave /t fields=root:acqBrowser:valMapField
	wave /t wnames=root:acqBrowser:valMapWave
	wave /t varname=root:acqBrowser:valMapVar
	wave isnum=root:acqBrowser:valMapIsNum
	
	wave /t objtables=root:acqBrowser:objMapTable
	wave /t objfields=root:acqBrowser:objMapField
	wave /t objfolder=root:acqBrowser:objMapFolder
	wave /t objwave=root:acqBrowser:objMapWave
	wave isImage=root:acqBrowser:objMapIsImage
	wave loadFrame=root:acqBrowser:objMapFrameNum

	wave /t funNames=root:acqBrowser:functionNames
	wave /t funExec=root:acqBrowser:functionExecStr
	

	for(i=0;i<numpnts(tables);i+=1)
		sprintf code, "%saddValMapping(\"%s\", \"%s\", \"%s\", \"%s\", %d);", code, tables[i], fields[i], wnames[i], varname[i], isnum[i]
		//printf "v"
	endfor

	for(i=0;i<numpnts(objtables);i+=1)
		sprintf code, "%saddObjMapping(\"%s\", \"%s\", \"%s\", \"%s\", %d, %d);",  code, objtables[i], objfields[i], objfolder[i], objwave[i], isimage[i], loadframe[i]
		//printf "o"
	endfor

	if(waveexists(funNames))
		for(i=0;i<numpnts(funnames);i+=1)
			sprintf code, "%saddFunction(\"%s\", \"%s\");",  code, funNames[i], replacestring("\"", funExec[i], "\\\\\"")
			//sprintf code, "%saddFunction(\"%s\", \"",  code, funNames[i]
			//code=code+replacestring("\"", funExec[i], "\\\\\"")
			//code=code+"\");"
			//long_code=addlistitem(code, long_code, ";", itemsinlist(long_code)-1)
			//printf "f"
			//print funNames[i], funExec[i]
		endfor
	endif

	wave /t run_me=root:acqbrowser:runOnUpdateAcq
	
	if(waveexists(run_me))
		for(i=0;i<numpnts(run_me);i+=1)
			sprintf code, "%sAppendTextVal(\"root:acqBrowser:runOnUpdateAcq\", \"%s\");",  code,  replacestring("\"", run_me[i], "\\\\\"")
		endfor
	endif

	wave /t run_me=root:acqbrowser:runOnDisplaySel
	
	if(waveexists(run_me))
		for(i=0;i<numpnts(run_me);i+=1)
			sprintf code, "%sAppendTextVal(\"root:acqBrowser:runOnDisplaySel\", \"%s\");",  code,  replacestring("\"", run_me[i], "\\\\\"")
		endfor
	endif

	wave /t modules=root:acqbrowser:modulenames
	
	if(waveexists(modules))
		for(i=0;i<numpnts(modules);i+=1)
			sprintf code, "%sregisterModule(\"%s\");",  code,  modules[i]
		endfor
	endif
	
	sql="INSERT INTO acqb_profile (profile_name, userinitials, igor_code) values('"+name+"', '"+user+"', '"+code+"')"
	//print sql

	PQxop/Q=sql
end

function loadUserProfile(name)
	string name
	string sql
	variable i
	
	sql="SELECT igor_code FROM acqb_profile WHERE profile_name='"+name+"'"
	
	PQxop/Q=sql
	
	if(getNtuples()!=1)
		print "Profile not found"
		return 0
	endif
	
	wave/t PQf_igor_code
	
	if(!waveexists(PQf_igor_code))
		print "cant find igor code"
		return 0
	endif
	
	for(i=0;i<itemsinlist(PQf_igor_code[0]);i+=1)
		print stringfromlist(i, PQf_igor_code[0])
		execute stringfromlist(i, PQf_igor_code[0])
	endfor

	pqclearres()

end

Function acqselect_btn(ctrlName) : ButtonControl
	String ctrlName
	nvar acq=$gets("root:acqbrowser:foldername", "")+":acq_count"

	//printf "%d ", acq

	if(cmpstr(ctrlname, "btn_up")==0)
		//printf "up"
		if(acq<getNumberOfAcqs()-1)
			acq+=1
		endif
	endif

	if(cmpstr(ctrlname, "btn_down")==0)
	//printf "dn"
		if(acq>0)
			acq-=1
		endif
	endif

	//print acq
	
	go_to_acq(acq)
	updateCheckBoxesByAcq()
End

Function acqselect_SetVar(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName

	
	
	go_to_acq_num(varnum)
	updateCheckBoxesByAcq()

End

Function SliderProc(ctrlName,sliderValue,event) : SliderControl
	String ctrlName
	Variable sliderValue
	Variable event	// bit field: bit 0: value set, 1: mouse down, 2: mouse up, 3: mouse moved

	if(event %& 0x1)	// bit 0, value set
		go_to_acq(slidervalue)
		//print slidervalue
		updateCheckBoxesByAcq()
	endif

	return 0
End

//	Slider slider0,limits={0,getNumberOfAcqs(),1},variable= root:current:acq_count,side= 0,vert= 0
Window acqBmainpanel() : Panel
	setdatafolder $gets("root:acqbrowser:foldername", "root:")
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(18,63,122,290)
	Dowindow /C acqB
	Slider slider0,pos={7,75},size={83,13},proc=SliderProc
	Slider slider0,limits={0,getMaxAcqNum(),1},variable= root:acqbrowser:acq_count,side= 0,vert= 0
	Button btn_up,pos={74,52},size={18,18},proc=acqselect_btn,title=">"
	Button btn_down,pos={6,52},size={18,18},proc=acqselect_btn,title="<"
	SetVariable setvar0,pos={32,54},size={35,16},proc=acqselect_SetVar,title=" "
	
	PopupMenu popup_sets,pos={9,25},size={73,21},proc=SelSetPopMenu,title="Set"
	PopupMenu popup_sets,mode=4,popvalue="foo",value= #"root:acqbrowser:setpopup"
	PopupMenu popup_disp,pos={7,135},size={71,21},proc=displaypopmenu,title="Display"
	PopupMenu popup_disp,mode=0,value= #"root:acqbrowser:displaypopup"

	PopupMenu popup_func,pos={7,160},size={71,21},proc=FunctionPopMenu,title="Functions"
	PopupMenu popup_func,mode=0,value= #"root:acqbrowser:functionpopup"


	CheckBox checkInSet,pos={5,95},size={79,14},proc=CheckBocProc,title="in current set"
	CheckBox checkInSet,value= 0
	CheckBox checkExclude,pos={5,113},size={55,14},proc=CheckBocProc,title="exclude"
	CheckBox checkExclude,value= 0
	
	SetVariable setvar0,limits={0,getMaxAcqNum(),0},value= root:acqbrowser:acq_num
	
	//print getMaxAcqNum(), root:acqbrowser:acq_num
	
EndMacro

function updateAcqNumDiplay()
	setdatafolder $gets("root:acqbrowser:foldername", "root:")

	doWindow /F acqB
	variable upper_lim = getMaxAcqNum()
	
	SetVariable setvar0,limits={0,upper_lim,0},value= root:acqbrowser:acq_num
end

Function DisplayPopMenu(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	wave isImage=root:acqBrowser:objMapIsImage
	
	if(!waveexists($popstr))
		return 0
	endif
	
	wave /t run_me=root:acqbrowser:runOnDisplaySel
	if(waveexists(run_me))
		variable i
		for(i=0;i<numpnts(run_me);i+=1)
			execute run_me[i]
		endfor
	endif

	if(get("root:acqBrowser:v_StopDisplay", 0)>0.5)
		set("root:acqBrowser:v_StopDisplay", 0)
		return 0
	endif
		
	if(isImage[popNum-1])
		//print isImage[popNum], popstr, popnum
		execute "newimage /k=1 "+popStr
	else
		execute "display /k=1 "+popStr
	endif
end

function makeDisplayPopupstring()
	variable i
	string list=""
	
	wave /t maps=root:acqBrowser:objMapWave
	
	for(i=0;i<numpnts(maps);i+=1)
		list=list+maps[i]+";"
		//sprintf list, "%s;%s;" maps[i]	
	endfor
	
	list=list[0,strlen(list)-2]
	
	sets("root:acqbrowser:displaypopup", list)
end

function makeFunctionPopupstring()
	variable i
	string list=""
	
	wave /t fun_names=root:acqBrowser:functionNames
	
	for(i=0;i<numpnts(fun_names);i+=1)
		sprintf list, "%s%s;" list, fun_names[i]	
	endfor
	
	list=list[0,strlen(list)-2]
	
	//print list
	
	sets("root:acqBrowser:functionpopup", list)
end

Function FunctionPopMenu(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	wave /t fun_exec=root:acqBrowser:functionExecStr
	
	execute fun_exec[popNum]
end

function addFunction(name, execstr)
	string name
	string execstr
	
	appendTextVal("root:acqBrowser:functionNames", name)
	appendTextVal("root:acqBrowser:functionExecStr", execstr)
	makeFunctionPopupstring()
end

Function SelSetPopMenu(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	if(cmpstr("New...", popstr)==0) 
		//get_new_set()
		newSet()
		return 0
	endif
	
	string setwavename=gets("root:acqbrowser:foldername", "")+":sets:"+popstr

	wave set=$setwavename

	if(waveexists(set))
		sets("root:acqbrowser:currentset_name", setwavename)
	endif
	
	updateCheckBoxesByAcq()

End

Function CheckBocProc(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked

	nvar acq=root:acqbrowser:acq_count

	if(cmpstr(ctrlName, "checkInSet")==0)
		wave tSet=$gets("root:acqbrowser:currentSet_name", "")
	else
		wave tSet=$gets("root:acqbrowser:foldername", "")+":sets:exclude"
	endif
	
	//print nameofwave(tset)
	
	tset[acq]=checked
	
	updateCheckBoxesByAcq()
End

function updateCheckBoxesByAcq()
	wave tSet=$gets("root:acqbrowser:currentSet_name", "")
	wave setX=$gets("root:acqbrowser:foldername", "")+":sets:exclude"
	
	nvar acq=root:acqbrowser:acq_count
	
	CheckBox checkInSet value=tset[acq]
	CheckBox checkExclude value=setx[acq]
end