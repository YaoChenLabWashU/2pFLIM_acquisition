function blasterNewConfiguration
	global state
	state.blaster.allConfigs(end+1, :)={'Default', [1 0 0.5 20 0 0]};
	makeBlasterConfigMenu