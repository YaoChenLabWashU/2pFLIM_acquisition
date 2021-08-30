function makeCycleMenu
	global state gh
	
	children=get(gh.timerMainControls.Cycles, 'Children');
	if ~isempty(children)
		delete(children);
	end
	
	if ~isempty(state.cycle.cyclePath)
		flist=dir([state.cycle.cyclePath '*.cyc']);
		uimenu(gh.timerMainControls.Cycles, 'Label', 'Cycle Definition...', 'Enable', 'on', 'Callback', 'seeGUI(''gh.advancedCycleGui.figure1'');');
		uimenu(gh.timerMainControls.Cycles, 'Label', state.cycle.cyclePath, 'Enable', 'on', 'Separator', 'on', 'Callback', 'setCyclesPath');
		
		for counter=1:length(flist)	
			if counter==1
				uimenu(gh.timerMainControls.Cycles, 'Label', flist(counter).name, 'Callback', 'selectCycleFromMenu' ...
					, 'Separator', 'on');
			else
				uimenu(gh.timerMainControls.Cycles, 'Label', flist(counter).name, 'Callback', 'selectCycleFromMenu');
			end
		end
	else
		uimenu(gh.timerMainControls.Cycles, 'Label', 'Set Cycles Path...', 'Enable', 'on', 'Callback', 'setCyclesPath');
		uimenu(gh.timerMainControls.Cycles, 'Label', 'Cycle Definition...', 'Enable', 'on', 'Separator', 'on', 'Callback', 'seeGUI(''gh.advancedCycleGui.figure1'');');
	end		