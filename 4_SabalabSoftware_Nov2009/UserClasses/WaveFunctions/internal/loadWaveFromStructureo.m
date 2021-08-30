function loadWaveFromStructureo(aStruct, name)
% Overload for load of classs wave.\
% kills wave if ti exisits
% a is what is saved, a structure array
% This is converted to a wave by the loadobj function
	fields = fieldnames(aStruct);		% a is a struct. First field is the name of the wave

	if nargin == 2
		if ischar(name)
			nameOfWave=name;
		else
			error('loadWaveFromStructure : expect name of wave as second parameter');
		end
	elseif nargin==1
		nameOfWave = fields{1};
	end
	
	waveProps = getfield(aStruct, fields{1});	% get wave props as a struct
	
	complete=waveo(nameOfWave, waveProps.data, ...
		'xscale', waveProps.xscale, ...
		'yscale', waveProps.yscale, ...
		'UserData', waveProps.UserData, ...
		'note', waveProps.note, ...
		'timeStamp', waveProps.timeStamp, ...
		'zscale', waveProps.zscale);
% 	if complete
% 		disp(['Loaded wave ' nameOfWave ' to workspace.']);
% 	end
	
