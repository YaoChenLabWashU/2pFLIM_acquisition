function resetPhysAverages(epochList)
	global state
	
	if nargin<1
		epochList=state.epoch;
	end

	addEntryToNotebook(2, ['Reset Phys Average, Epoch ' num2str(epochList)]);

	for epoch=epochList
		for channel=0:7
			if isnumeric(epoch)
				names=evalin('base', ['whos(physAvgName(' num2str(epoch) ',' num2str(channel) ', ''*''))']);
			else
				names=evalin('base', ['whos(physAvgName(''' epoch ''',' num2str(channel) ', ''*''))']);
			end
			for counter=1:length(names)
				disp(['*** Clearing ' names(counter).name ' ***']);
				resetAverage(names(counter).name);
				kill(names(counter).name, 'q');
			end
		end
	end
