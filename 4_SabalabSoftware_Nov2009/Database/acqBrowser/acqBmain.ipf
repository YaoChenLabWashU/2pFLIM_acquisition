#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------
// browser, current acq stuff.
//-------------------------------

function init_mappings()
	//DO NOT RUN EXCEPT TO CREATE NEW USER PROFILES
	
	addValMapping("acquisition", "epoch", "epoch", "epochvar", 1)
	addValMapping("acquisition", "cycleposition", "cycleposition", "cyclepositionvar", 1)
	addObjMapping("physacq", "wave_id", "phys", "ad0", 0, -1)
	//addObjMapping("imagingacq", "tiff_lo_oid", "green_ims", "green", 1, 0)
	//addObjMapping("imagingacq", "tiff_lo_oid", "red_ims", "red", 1, 1)
	
end

function registerModule(modname)
	string modname
	variable modnum
	
	appendTextVal("root:acqbrowser:moduleNames", modname)
	if(cmpstr(gets("root:acqbrowser:foldername", ""), "")!=0) //cell is currently loaded
		modnum=numpnts(root:acqbrowser:moduleNames)-1;
		initializeModule(modnum)	
	endif
end

function initializeModule(modnum)
	variable modnum
	string modname
	string curfolder
	curfolder=gets("root:acqbrowser:foldername", "")
	
	wave /t names=root:acqbrowser:moduleNames
	if(!waveexists(names) || numpnts(names) <= modnum || cmpstr(curfolder, "")==0)
		//print "hello"
		return 0
	endif

	modname=names[modnum]
	
	setdatafolder $curfolder
	
	execute "newdatafolder /o "+modname
	
	sets("root:acqbrowser:"+modname+"_folder", curfolder+":"+modname)
	
	execute modname+"_init()"
end

function updateacq()
	nvar acq=acq_count
	go_to_acq(acq)
end

function go_to_acq_num(an)
	variable an
	wave acq_num=acq_num_wave
	findlevel/q acq_num, an
	go_to_acq(v_levelx)
end

function go_to_acq(count)
	variable count
	nvar acq_num
	nvar acq_count
	nvar acq_num_lass_success
	nvar acq_count2=root:acqbrowser:acq_count
	nvar acq
	//print count, acq_count

	
	if(count<0 || count>=getNumberOfAcqs() || numtype(count)==2) 
		set("acq_num", get("acq_num_lass_success", 0))
		return 0
	endif
	
	wave acq_num_wave=acq_num_wave
	
	//print count, acq_count
	
	acq_count=count
	acq_num=acq_num_wave[count]

	//print count, acq_count, acq_count2

	set("acqbrowser:acq_count", acq_count)
	set("acqbrowser:acq_num", acq_num)

	updateObjMapsByAcq() 
	//updateValMapsByAcq() 
	
	//print count, acq_count, acq_count2
	
	
	acq_num_lass_success=acq_num_wave[count]
	
	wave /t run_me=root:acqbrowser:runOnUpdateAcq
	
	if(waveexists(run_me))
		variable i
		for(i=0;i<numpnts(run_me);i+=1)
			execute run_me[i]
		endfor
	endif
	
	wave /t modnames=root:acqbrowser:moduleNames
	if(waveexists(modnames))
		for(i=0;i<numpnts(modnames);i+=1)
			execute/z modnames[i]+"_updateacq()"
		endfor
	endif
end

function getNumberOfAcqs()
	wave w=$gets("root:acqbrowser:foldername", "")+":acq_num_wave"

	return numpnts(w)
end
 
function getMaxAcqNum()
	wave w=$gets("root:acqbrowser:foldername", "")+":acq_num_wave"
	//print w[0]
	return w[numpnts(w)-1]
end

function goToCell(cellnum)
	variable cellnum
	string cellname, foldername

	wave /t cellList=root:acqBrowser:cellList

	cellname=cellList[cellnum]

	foldername="root:c"+cellname

	sets("root:acqbrowser:cell", cellname)
	sets("root:acqbrowser:foldername", foldername)

	setdatafolder foldername
	
	makeSetPopupstring()
	
	//killvariables /z root:acqbrowser:acq_count
	//killvariables /z root:acqbrowser:acq_num	
	
	//setdatafolder root:acqbrowser
	
	//execute "variable /g acq_count:="+foldername+":acq_count"
	//execute "variable /g acq_num:="+foldername+":acq_num"
	
	//setdatafolder foldername
	
	//need to go to current acq
	go_to_acq(0)
	
	// also need to change slider
end

//------------------------------
// Loading cells
//------------------------------


function killCell(num)
	variable num
	gotocell(num)

	//first undo dependencies
	wave /t varname=root:acqBrowser:valMapVar
	variable i	
	for(i=0;i<numpnts(varname);i+=1)
		execute "killvariables /z "+varname[i]
	endfor
	
	// then kill open graphs
	
	//finaly kill folders
	setdatafolder root:
	
	killdatafolder $gets("root:acqbrowser:foldername", "")
	
	//print "Not implemented"

end

function loadCellFromDB(cell_id)
	variable cell_id
	string sql, foldername, varname, valname
	variable i
	
	DoWindow /K celltable
	
	PQclearRes()
	
	sql="SELECT * FROM cell WHERE cell_id="+num2str(cell_id)
	
	PQxop/Q=sql
	
	if(getNtuples()!=1)
		print "Not unique cell_id or cell not found"
		return 0
	endif
	
	wave/t PQf_cellname, PQ_fnames
	
	foldername="root:c"+PQf_cellname[0]
	
	execute "NewDataFolder/O "+foldername
	
	for(i=0;i<numpnts(PQ_fnames);i+=1)
		varname=foldername+":"+PQ_fnames[i]
		valname="root:PQf_"+PQ_fnames[i]+"[0]"
		execute "string /g "+varname
		execute varname+"="+valname
	endfor

	//PQclearRes()
	
	sets("root:acqBrowser:cell", PQf_cellname[0])
	sets("root:acqBrowser:foldername", foldername)
	
	appendTextVal("root:acqBrowser:cellList", PQf_cellname[0])
	
	PQclearRes()

	execute "setDataFolder "+foldername

	variable /g acq_count=0
	variable /g acq_num=0
	variable /g acq_num_last_success=0

	

	MakeAcqWave()	
	initSetsInCurrent()


	getValMapsFromDB()
	getObjMapsFromDB()
	 	 	 
	gotocell(numpnts(root:celllist)-1)

	makeSetPopupstring()
	makedisplaypopupstring()
	
	loadComments()
	
	//initialize modules
	if(waveexists(root:acqbrowser:moduleNames))
		for(i=0;i<numpnts(root:acqbrowser:moduleNames);i+=1)
			initializeModule(i)	
		endfor
	endif
	
end

function loadComments()
	svar cell_id
	
	pqclearres()
	PQXop/Q="SELECT * from cellComments WHERE cell_id="+cell_id

	duplicate /o PQf_time commentTime
	duplicate /o PQf_comment commentString
	Edit/k=1/W=(5.25,41.75,466.5,378.5) commentTime,commentString
	ModifyTable width(Point)=0,width(commentTime)=102,alignment(commentString)=0,width(commentString)=347
	pqclearres()

end


function doForEachAcqInSet(funcstr)
	string funcstr
	nvar acq=acq_count	
	variable current_acq_count=acq
	
	wave tSet=$gets("root:acqBrowser:currentSet_name", "")
	wave setX=$gets("root:acqBrowser:foldername", "")+":sets:exclude"

	variable max_acq=getNumberOfAcqs()
	
	for(acq=0;acq<max_acq;acq+=1)
		if(tset[acq] && !setX[acq])
			go_to_acq(acq)
			execute funcstr	
		endif
	endfor
	
	acq=current_acq_count
	updateacq()
	
end


//----------------
// Mid-level database functions
//----------------

function MakeAcqWave()
	svar cell_id=cell_id

	string sql
	sql="SELECT acq_id, acq_num FROM acquisition WHERE cell_id="+cell_id+" ORDER BY acq_num ASC"
	PQxop/Q=sql
	
	wave /t PQf_acq_id, PQf_acq_num
	
	make/o/n=(getNtuples()) acq_id, acq_num_wave
	acq_id=str2num(PQf_acq_id)
	acq_num_wave=str2num(PQf_acq_num)

	//duplicate /o PQf_acq_id acq_id
	//duplicate /o PQf_acq_num acq_num
	
	PQclearres()
end


//----------------
// Low-level database functions
//----------------

function PQclearRes()
	killbyname("PQf_")
	killwaves/z PQ_row
	killwaves/z PQ_fnames
end

function PQtable(sql)
	string sql
	variable i
	
 	PQclearRes()

	PQxop/Q=sql
	
	wave/t PQ_fnames
	
	if(waveexists(PQ_fnames))	
	for(i=0;i<numpnts(PQ_fnames);i+=1) 
		execute("appendtotable PQf_"+PQ_fnames[i])
		execute("ModifyTable title(PQf_"+PQ_fnames[i]+")=\""+PQ_fnames[i]+"\"")
	endfor
	endif
end

function getNtuples()
	wave /t PQ_fnames
	string wname

	if(!waveexists(PQ_fnames))
		return 0
	endif
	
	wname="PQf_"+PQ_fnames[0]
	
	return numpnts($wname)
end

//browser functions generatred by igot

