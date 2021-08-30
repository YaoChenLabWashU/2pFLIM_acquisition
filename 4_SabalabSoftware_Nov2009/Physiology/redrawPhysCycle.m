function redrawPhysCycle
	global state gh
	
	if state.phys.cycle.startingPos > size(state.phys.cycle.cycleDef,1)-3
		state.phys.cycle.startingPos=max(size(state.phys.cycle.cycleDef,1)-3, 1);
		state.phys.cycle.startingPos=101-state.phys.cycle.startingPosFlip;
		updateGUIByGlobal('state.phys.cycle.startingPosFlip');
	end
	
	for counter=state.phys.cycle.startingPos:state.phys.cycle.startingPos + 3
		eval(['state.phys.cycle.pos' num2str(counter - state.phys.cycle.startingPos + 1) '=counter;']);
		updateGUIByGlobal(['state.phys.cycle.pos' num2str(counter - state.phys.cycle.startingPos + 1)]);
		if counter > size(state.phys.cycle.cycleDef,1)
			eval(['state.phys.cycle.rep' num2str(counter - state.phys.cycle.startingPos + 1) '=0;']);
			eval(['state.phys.cycle.delay' num2str(counter - state.phys.cycle.startingPos + 1) '=0;']);
			eval(['state.phys.cycle.da0_' num2str(counter - state.phys.cycle.startingPos + 1) '=0;']);
			eval(['state.phys.cycle.da1_' num2str(counter - state.phys.cycle.startingPos + 1) '=0;']);
			eval(['state.phys.cycle.aux_' num2str(counter - state.phys.cycle.startingPos + 1) '=0;']);
		else
			eval(['state.phys.cycle.rep' num2str(counter - state.phys.cycle.startingPos + 1) '=state.phys.cycle.cycleDef(counter,1);'])
			eval(['state.phys.cycle.delay' num2str(counter - state.phys.cycle.startingPos + 1) '=state.phys.cycle.cycleDef(counter,2);']);
			eval(['state.phys.cycle.da0_' num2str(counter - state.phys.cycle.startingPos + 1) '=state.phys.cycle.cycleDef(counter,3);']);
			eval(['state.phys.cycle.da1_' num2str(counter - state.phys.cycle.startingPos + 1) '=state.phys.cycle.cycleDef(counter,4);']);
			eval(['state.phys.cycle.aux_' num2str(counter - state.phys.cycle.startingPos + 1) ...
					'=state.phys.cycle.cycleDef(counter, 5 + state.phys.cycle.auxCounter);']);
		end
			
		updateGUIByGlobal(['state.phys.cycle.rep' num2str(counter - state.phys.cycle.startingPos + 1)]);
		updateGUIByGlobal(['state.phys.cycle.delay' num2str(counter - state.phys.cycle.startingPos + 1)]);			
		updateGUIByGlobal(['state.phys.cycle.da0_' num2str(counter - state.phys.cycle.startingPos + 1)]);			
		updateGUIByGlobal(['state.phys.cycle.da1_' num2str(counter - state.phys.cycle.startingPos + 1)]);		
		updateGUIByGlobal(['state.phys.cycle.aux_' num2str(counter - state.phys.cycle.startingPos + 1)]);		
	end
	updateGUIByGlobal('state.phys.cycle.rsPulseVC');
	updateGUIByGlobal('state.phys.cycle.rsPulseCC');
	updateGUIByGlobal('state.phys.cycle.cycleName');	