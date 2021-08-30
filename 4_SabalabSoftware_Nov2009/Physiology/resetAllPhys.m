function resetAllPhys
	button=questdlg('Do you really want to reset and erase all data in memory?', 'RESET ?', 'Yes', 'No', 'Cancel', 'No');
	if ~strcmp(button, 'Yes')
		setPhysStatusString('Reset Cancelled');
		return
	end

	waveo('physAcqTrace', repmat(nan, 1, 1000));
	waveo('physAcqTime0', repmat(nan, 1, 1000));
	waveo('physAcqTime1', repmat(nan, 1, 1000));	
	waveo('physCellRm0', repmat(nan, 1, 1000));
	waveo('physCellRs0', repmat(nan, 1, 1000));
	waveo('physCellCm0', repmat(nan, 1, 1000));
	waveo('physCellVm0', repmat(nan, 1, 1000));
	waveo('physCellIm0', repmat(nan, 1, 1000));
	waveo('physCellRm1', repmat(nan, 1, 1000));
	waveo('physCellRs1', repmat(nan, 1, 1000));
	waveo('physCellCm1', repmat(nan, 1, 1000));
	waveo('physCellVm1', repmat(nan, 1, 1000));
	waveo('physCellIm1', repmat(nan, 1, 1000));	

	global state
	setPhysStatusString('Resetting...');
	resetPhysAverages('*');
	for channel=0:7
		names=evalin('base', ['whos(physTraceName(' num2str(channel) ', ''*''))']);
		for counter=1:length(names)
			killq(names(counter).name);
		end
	end
	state.files.savePath='';
	state.epoch=1;
	updateGUIByGlobal('state.epoch');
	state.phys.cycle.positionInCycle=1;
	updateGUIByGlobal('state.phys.cycle.positionInCycle');
	state.phys.cycle.repeatsDone=0;
	updateGUIByGlobal('state.phys.cycle.repeatsDone');
	state.files.fileCounter=1;
	updateGUIByGlobal('state.files.fileCounter');
	setPhysStatusString('Reset Done');
	state.notebook.notebookText1='';
	state.notebook.notebookText2='';
	updateNotebookDisplay;
