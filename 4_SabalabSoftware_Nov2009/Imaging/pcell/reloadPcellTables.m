function reloadPcellTables
	global state
	
	if state.pcell.pcellOn
		setStatusString('Loading pcell tables');
		if ~isempty(state.pcell.pcellTablePath) && ischar(state.pcell.pcellTablePath)
	%		cd(state.pcell.pcellTablePath);
			pname=state.pcell.pcellTablePath;
	
			for chan=1:state.pcell.numberOfPcells
				fname = eval(['state.pcell.pcellTableName' num2str(chan)]);
				if ischar(fname) && ~isempty(fname)
					periods=findstr(fname, '.');
					if any(periods)								
						fname=fname(1:periods(1)-1);
					end		
			
					load(fullfile(pname, [fname '.pow']), '-mat');			% load file as MATLAB workspace file
					eval(['state.pcell.pcellTableName' num2str(chan) '=fname;']);
					eval(['state.pcell.powerLookupTable' num2str(chan) '=plt;']);
					disp(['Loaded power table for channel ' num2str(chan) ' from ' fullfile(pname, [fname '.pow'])]);
				end
			end
							
			global gh
			turnOnAllChildren(gh.pcellControl.figure1);
			if ~state.analysisMode && ~state.initializing
				state.internal.needNewPcellPowerOutput=1;
				applyChangesToOutput;
			end
			setStatusString('');
% 		else
% 			beep
% 			setStatusString('INCORRECT PCELL PATH');
% 			disp('*** INCORRECT PCELL PATH');
		end	
	end