function setupCycleRandomList
	global state
	
    fprintf('\nFromRandomizeList:\nPulseToUse0: %d, Blaster = %d\n\n',state.cycle.pulseToUse0,state.cycle.blaster); %#ATL
    
    disp('*** Randomizing call order for cycle positions ***');
	temp=[];
	for counter=1:length(state.cycle.delayList)
		if state.cycle.repeatsList(counter)>0 & (state.cycle.physOnList(counter) | state.cycle.imageOnList(counter))
			temp(end+1:end+1+state.cycle.repeatsList(counter))=counter;
		end
	end
	if ~isempty(temp)
		r=rand(1, length(temp));
		[y,i]=sort(r);
		state.internal.randomPositionsList=temp(i);
	else
		state.internal.randomPositionsList=0;
	end
	state.internal.randomPosition=1;
		
			