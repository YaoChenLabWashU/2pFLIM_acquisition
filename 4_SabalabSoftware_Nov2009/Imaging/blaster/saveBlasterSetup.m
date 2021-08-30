function saveBlasterSetup

	global state
	
	if isempty(state.blaster.setupPath) | isempty(state.blaster.setupName)
		saveBlasterSetupAs;
	else
		blaster=[];
		for field=state.blaster.paramList
			blaster=setfield(blaster, field{1}, getfield(state.blaster, field{1}));
		end
 		save(fullfile(state.blaster.setupPath, state.blaster.setupName), 'blaster', '-MAT');
		setStatusString('Blaster setup saved');
	end
