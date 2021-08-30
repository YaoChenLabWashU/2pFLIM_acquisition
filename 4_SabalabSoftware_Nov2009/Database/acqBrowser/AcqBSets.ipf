#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------
// browser, current acq stuff.
//-------------------------------

function makeSetPopupstring()
	setdatafolder sets
	string list
	list=wavelist("*", ";", "")
	list+="New..."
	sets("root:acqbrowser:setpopup", list)
	
	setdatafolder ::
end

//------------------------------
// Loading cells
//------------------------------

function initSetsInCurrent()
	execute "NewDataFolder/O "+gets("root:acqbrowser:foldername", "")+":sets"
	 
 	 execute "setdatafolder "+gets("root:acqbrowser:foldername", "")
 		 
	 duplicate/o acq_num_wave :sets:all
	 duplicate/o acq_num_wave :sets:none
 	 duplicate/o acq_num_wave :sets:exclude
 	 
 	 execute "setdatafolder "+gets("root:acqbrowser:foldername", "")+":sets"
 	 
 	 execute "all=1"
 	 execute "none=0"
 	 execute "exclude=0"
	 
 	 execute "setdatafolder "+gets("root:acqbrowser:foldername", "")

	 sets("root:acqbrowser:currentSet_name", gets("root:acqbrowser:foldername", "")+":sets:all")
end


function newSet()
	string set_name

	make/o/n=(getmaxvalinmapping("epoch")) root:acqBrowser:avEpochs
	make/o/n=(getmaxvalinmapping("cyclepos")) root:acqBrowser:avCyclePos

	edit 	/k=1 root:acqBrowser:avEpochs, root:acqBrowser:avCyclePos
	
	dowindow/c AverageWhat
	pauseforuser AverageWhat
	
	set_name=""
	
	prompt set_name, "Set Name:"
	doprompt "Enter set name", set_name

	if(cmpstr(set_name, "") !=0)
		calcSet(set_name)
	endif
end

function calcSet(set_name)
	string set_name
	wave av_epochs=root:acqBrowser:avEpochs
	wave av_cycpos=root:acqBrowser:avCyclePos
	
	wave ep_wave=$"root:"+gets("root:acqbrowser:foldername", "")+":epoch"
	wave cyc_wave=$"root:"+gets("root:acqbrowser:foldername", "")+":cycleposition"
	
	make/o/n=(getNumberOfAcqs()) $gets("root:acqbrowser:foldername", "")+":sets:"+set_name
	wave set=$"root:"+gets("root:acqbrowser:foldername", "")+":sets:"+set_name
	
	set=av_epochs[ep_wave[p]]>0.5 && av_cycpos[cyc_wave[p]]>0.5 

	makesetpopupstring()
end

