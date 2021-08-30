function makePcellLookupTable(chan)
	if nargin<1
		chan=1;
	end
	global state
	
	[hi, hiloc]=max(state.pcell.pcellTestIn);
    [lo, loloc]=min(state.pcell.pcellTestIn);
	
    if loloc<hiloc
        start=loloc;
        last=hiloc;
    elseif hiloc<loloc
        start=hiloc;
        last=loloc;
    else
        disp('Error: Low power level and high power level found at same voltage');
        return;
    end
        
        
	norm=round(1000*(state.pcell.pcellTestIn-lo)/(hi-lo))+1;
	startVolt=state.pcell.pcellTestOut(start);
	endVolt=state.pcell.pcellTestOut(last);
	
	powerLookupTable=linspace(startVolt, endVolt, 1001);
	
% 	for counter=start+1:last
% 		startVolt=state.pcell.pcellTestOut(counter-1);
% 		endVolt=state.pcell.pcellTestOut(counter);
% 		startPower=norm(counter-1);
% 		endPower=norm(counter);
% 		if startPower==endPower
% 			powerLookupTable(startPower) = startVolt;
% 		else
% 			powerLookupTable(startPower:endPower) = startVolt:(endVolt-startVolt)/(endPower-startPower):endVolt;
% 		end
% 	end
% 	
	eval(['state.pcell.powerLookupTable' num2str(chan) '=powerLookupTable;']);
	eval(['global pcellLookupTableWave' num2str(chan)]);
	if ~exist(['pcellLookupTableWave' num2str(chan)]) 
		wave(['pcellLookupTableWave' num2str(chan)], powerLookupTable, 'xscale', [0 .1]);
	elseif eval(['iswave(pcellLookupTableWave' num2str(chan) ')'])
		eval(['pcellLookupTableWave' num2str(chan) '.data = powerLookupTable;']);
	else
		wave(['pcellLookupTableWave' num2str(chan)], powerLookupTable, 'xscale', [0 .1]);
	end

		