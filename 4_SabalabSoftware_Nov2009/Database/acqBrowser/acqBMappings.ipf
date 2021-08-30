#pragma rtGlobals=1		// Use modern global access method.

function addValMapping(table, field, wave_name, var_name, isNumeric)
	string table
	string field
	string wave_name
	string var_name
	variable isNumeric

	appendTextVal("root:acqBrowser:valMapTable", table)
	appendTextVal("root:acqBrowser:valMapField", field)
	appendTextVal("root:acqBrowser:valMapWave", wave_name)
	appendTextVal("root:acqBrowser:valMapVar", var_name)
	appendVal("root:acqBrowser:valMapIsNum", isNumeric)
end

function addObjMapping(table, field, folder_name, wave_name, isImage, framenum)
	string table
	string field
	string folder_name
	string wave_name
	variable isImage
	variable framenum

	appendTextVal("root:acqBrowser:objMapTable", table)
	appendTextVal("root:acqBrowser:objMapField", field)
	appendTextVal("root:acqBrowser:objMapFolder", folder_name)
	appendTextVal("root:acqBrowser:objMapWave", wave_name)
	appendVal("root:acqBrowser:objMapFrameNum", framenum)
	appendVal("root:acqBrowser:objMapIsImage", isimage)
end

function updateObjMapsByAcq() 
	variable i
	nvar acq=root:acqbrowser:acq_count
	
	//print acq
	
	wave /t objfolder=root:acqBrowser:objMapFolder
	wave /t objwave=root:acqBrowser:objMapWave

	//svar current_folder=root:current:foldername
	string obj_folder_name
	string obj_src_wave
	string obj_src_wave_fullname
	
	for(i=0;i<numpnts(objFolder);i+=1)
		obj_folder_name=gets("root:acqbrowser:foldername", "")+":"+objFolder[i]
		//print "in folder ", obj_folder_name
		wave /t wname=$obj_folder_name+"_names"
		obj_src_wave=wname[acq]
		obj_src_wave_fullname=obj_folder_name+":"+obj_src_wave
		wave thewave=$obj_src_wave_fullname
		if(waveexists(thewave))
			execute "duplicate /o "+obj_src_wave_fullname+" "+objwave[i]
			sets("root:acqbrowser:"+objwave[i]+"_name", obj_src_wave_fullname)
			//printf "acq %d copy from %s to %s\r", acq, obj_src_wave_fullname, objwave[i]
		else
			sets("root:acqbrowser:"+objwave[i]+"_name", "")
			//print "wave not found:", obj_src_wave_fullname
			wave w2=$objwave[i]
			if(waveexists(w2))
				execute objwave[i]+"=nan"			
			endif
		endif
	endfor
end

function getValMapsFromDB()
	variable i

	wave /t tables=root:acqBrowser:valMapTable
	wave /t fields=root:acqBrowser:valMapField
	wave /t wnames=root:acqBrowser:valMapWave
	wave isnum=root:acqBrowser:valMapIsNum
	wave /t varname=root:acqBrowser:valMapVar
	
	for(i=0;i<numpnts(tables);i+=1)
		if(isnum[i])
			mapfieldtowave(tables[i], fields[i])
		else
			mapfieldtotextwave(tables[i], fields[i])
		endif
		if(cmpstr(fields[i], wnames[i])!=0)
			Rename $fields[i], $wnames[i]
		endif
		
		execute "killvariables /z "+varname[i]
		execute "variable /g "+varname[i]+" := "+wnames[i]+"[acq_count]"
	endfor
end


function getObjMapsFromDB()
	wave /t tables=root:acqBrowser:objMapTable
	wave /t fields=root:acqBrowser:objMapField
	wave /t folder=root:acqBrowser:objMapFolder
	wave isImage=root:acqBrowser:objMapIsImage
	wave loadFrame=root:acqBrowser:objMapFrameNum

	wave acq_num=acq_num_wave

	variable i, j, im
	string im_wave_name
	
	for(i=0;i<numpnts(tables);i+=1)
		setdatafolder $gets("root:acqBrowser:foldername", "")
		mapfieldtotextwave(tables[i], fields[i])
		wave /t obj_id=$fields[i]
		make/o/t/n=(numpnts(acq_num)) $folder[i]+"_names"
		wave /t wnames=$folder[i]+"_names"
		execute "newdatafolder /o/s "+folder[i]
		wnames=""
				
		if(isImage[i])
			//set path
			NewPath /C/q/O tempfolder "C:temp:"
			pathinfo/s temppath
			deletefile/p=tempfolder/z "lobj_tempfile"
			
			for(j=0;j<numpnts(obj_id);j+=1)
				wnames[j]="" //initialize to empty by default
				if(strlen(obj_id[j])>0)
					PQxop/R=obj_id[j]
					if(fileExists("tempfolder", "lobj_tempfile"))
						im_wave_name=folder[i]+"_"+num2str(acq_num[j]) //educated guess
						if(loadFrame[i]<-0.5) //load all frames
							ImageLoad/o/q/P=tempfolder/T=tiff/S=0 /C=10000 "lobj_tempfile"
							wave the_im=$stringfromlist(0, s_wavenames)
							make/o/i/n=(dimsize(first,0), dimsize(first, 1), v_numImages) my_image
							for(im=0;im<v_numImages;im+=1)
								wave the_im=$stringfromlist(im, s_wavenames)
								my_image[][][im]=the_im[p][q]
							endfor
							duplicate /o my_image $im_wave_name; killwaves myimage
							wnames[j]=im_wave_name
						else
							ImageLoad/o/q/P=tempfolder/T=tiff/S=(loadframe[i]) /C=1 "lobj_tempfile"
							if(cmpstr(s_wavenames, "")!=0) //we have loaded an image
								duplicate /o $stringfromlist(0, s_wavenames) $im_wave_name; killwaves $stringfromlist(0, s_wavenames)
								wnames[j]=im_wave_name
							endif
						endif
						
						deletefile/p=tempfolder/z "lobj_tempfile"
					endif
				endif
			endfor
		else //is a wave
			for(j=0;j<numpnts(obj_id);j+=1)
				if(strlen(obj_id[j])>0)
					PQxop/G=obj_id[j]
					wnames[j]=strvarordefault("PQ_wavename", "")
					killstrings/z PQ_wavename
				endif
			endfor
		endif		
		killwaves /z obj_id
	endfor

	execute "setdatafolder "+gets("root:acqBrowser:foldername", "")

end


//----------------
// Mid-level database functions
//----------------




function MapFieldToWave(table, field)
	string table
	string field
		
	string SQL
	variable nacqs, acq
	wave acq_id
		
	SQL="SELECT acq_id, "+field+" FROM "+table+" ORDER BY acq_id ASC"
	//print sql
	PQxop/Q=sql
	nacqs=getntuples()
	
	if(nacqs<1)
		print "found no acqs"
		return 0
	endif
	
	wave /t PQf_acq_id
	make/o/n=(numpnts(acq_id)) $field
	make/o/n=(nacqs) found_acq_ids
	found_acq_ids=str2num(PQf_acq_id)
	
	wave /t fields=$"PQf_"+field
	wave target=$field
	target = nan
	for(acq=0;acq<nacqs;acq+=1)
		findlevel/q acq_id, found_acq_ids[acq]
		target[v_levelx]=str2num(fields[acq])	
	endfor
	killwaves /z found_acq_ids
	PQclearres()
end

function MapFieldToTextWave(table, field)
	string table
	string field
		
	string SQL
	variable nacqs, acq
	wave acq_id
	
	
	SQL="SELECT acq_id, "+field+" FROM "+table+" ORDER BY acq_id ASC"
	//print sql
	PQxop/Q=sql
	nacqs=getntuples()
	
	if(nacqs<1)
		print "found no acqs"
		return 0
	endif
	
	wave /t PQf_acq_id
	make/o/t/n=(numpnts(acq_id)) $field
	make/o/n=(nacqs) found_acq_ids
	found_acq_ids=str2num(PQf_acq_id)
	
	wave /t fields=$"PQf_"+field
	wave /t target=$field
	target = ""
	for(acq=0;acq<nacqs;acq+=1)
		findlevel/q acq_id, found_acq_ids[acq]
		target[v_levelx]=fields[acq]	
	endfor
	killwaves /z found_acq_ids
	PQclearres()
end

function getMaxValInMapping(name) 
	string name
	variable i
	nvar acq=root:current:acq_count
	
	wave /t valwave=root:acqbrowser:valMapWave
	wave /t valvar=root:acqbrowser:valMapVar
	wave isNum=root:acqbrowser:valMapIsNum
	
	i=findTextInWave(valwave, name)
	if(i<0)
		return Nan
	else
		wavestats /q $valwave[i]
		return v_max
	endif
	
end

function findTextinWave(w, str) 
	wave/t w
	string str
	variable i
	
	for(i=0;i<numpnts(w);i+=1)
		if(cmpstr(str, w[i])==0)
			return i
		endif
	endfor

	return -1
end