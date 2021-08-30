function toggleCycleGUIS(onoff)
	global state gh
	if nargin<1
		onoff=~state.cycle.writeProtect;
	end
	
	if onoff
		string='on';
	else
		string='off';
	end
	
	list2=[state.internal.cycleListNames {'VCRCPulse' 'CCRCPulse' 'randomize' 'insertCyclePos' 'deleteCyclePos'}];
	for counter=1:length(list2)
		tag=list2{counter};
		eval(['set(gh.advancedCycleGui.' tag ', ''Enable'', ''' string ''');']);
		if isfield(gh.advancedCycleGui, [tag 'Slider'])
			eval(['set(gh.advancedCycleGui.' tag 'Slider, ''Enable'', ''' string ''');']);
		end
	end
	