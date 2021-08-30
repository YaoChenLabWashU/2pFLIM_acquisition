function startScopeLoop
	global state gh
	
	updateMinInCell;
	reset=0;

	if state.phys.scope.needToStop==1
		stopScope;
	else
		readTelegraphs;
		if state.phys.internal.needNewScopeOutput  
			makeScopeOutput;
			state.phys.internal.needNewScopeOutput=0;
		end
		if state.phys.internal.scopeChannelChanged
			resetScopeDaq;
			reset=1;
			state.phys.internal.scopeChannelChanged=0;
		end

		if state.phys.scope.firstTime
			state.phys.scope.firstTime=0;
			state.phys.scope.counter=0;
		else
			while etime(clock, state.phys.daq.scopeTriggerTime)<1/state.phys.scope.frequency
				if state.phys.scope.needToStop==1
					stopScope;
					return;
				else
					readTelegraphs;
					if state.phys.internal.needNewScopeOutput  
						makeScopeOutput;
						state.phys.internal.needNewScopeOutput=0;
					end
					if state.phys.internal.scopeChannelChanged
						resetScopeDaq;
						state.phys.internal.scopeChannelChanged=0;
						reset=1;
					end
					if ~reset
						readBaseline;
					end
					pause(0.01);
				end
			end
		end
		startScope;
	end
