function appendData(wv,data)
% Appends some data to a wave without the need to open it and check it..  Data and wave must be one-D.
% Updated for use with chars, waves, or cell arrays of waves.

if nargin ~= 2
	error('appendData: inputs must be a wave or a string wave name and the data to append.');
end

if iscellstr(wv)
    if all(iscellwave(wv))
        waveCell=wv;
    else
        error('appendData: 1st argument must be a wave,wave name, or cell array of wave names');
    end
elseif iswave(wv)
    if ~ischar(wv)
        waveCell = {inputname(1)};
    else
        waveCell={wv};
    end
else
    error('appendData: 1st argument must be a wave,wave name, or cell array of wave names');
end

for waveCounter=1:length(waveCell)
	waveName=waveCell{waveCounter};
	olddata=get(waveName,'data');
	if (numdims(data)<2) & (numdims(olddata)<2)
		if isnan(olddata)	%We made this one so data is empty
			setWave(waveName,'data',[data]);
		else
			setWave(waveName,'data',[olddata data]);
		end
	else
		error('appendData: wave and data must be one-dimensional.');
	end
end
