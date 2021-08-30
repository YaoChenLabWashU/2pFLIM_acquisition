function kill(wv,flag)
% Removes waves fromt he workspace.
% Accepts wave, wave name, or cell array of wave names.
% The flag sent in can be: 
% 'n' for mormal mode (can't kill on plots, so reads an error)
% 'o' for overwrite which will remove the wave from any plots and then kill it.
% 'q' tries to kill it but if it is on any pltos does ntohing and reads no error.

if nargin == 1
	flag='n';
elseif nargin > 2
	error('kill: first input must be a wave or name of a wave and the second a flag');
end

if iscellstr(wv)
	if all(iscellwave(wv))
		waveCell=wv;
	else
		error('kill: 1st argument must be a wave,wave name, or cell array of wave names');
	end
elseif iswave(wv)
	if ~ischar(wv)
		waveCell = {inputname(1)};
	else
		waveCell={wv};
	end
else
	error('kill: 1st argument must be a wave,wave name, or cell array of wave names');
end

for waveCounter=1:length(waveCell)
	waveName=waveCell{waveCounter};
	plots=getWave(waveName,'plot');
	switch flag
		case 'n'
			if ~isempty(plots)
				error(['kill: Cannot kill ' waveName '. Wave is in plots. Use removeall(' waveName ') then kill(' waveName ') or use killo(' waveName ')']);
			end
		case 'q'
			if ~isempty(plots)
				return
			end
	end
	killo(waveName);
end

