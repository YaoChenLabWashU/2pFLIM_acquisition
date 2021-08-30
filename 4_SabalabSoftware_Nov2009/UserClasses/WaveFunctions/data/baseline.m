function baseline(wv, n)

%FS created
if nargin ~= 2
	error('baseline: inputs must be a wave or a string wave name and number of baseline points.');
end

if iscellstr(wv)
    if all(iscellwave(wv))
        waveCell=wv;
    else
        error('baseline: 1st argument must be a wave,wave name, or cell array of wave names');
    end
elseif iswave(wv)
    if ~ischar(wv)
        waveCell = {inputname(1)};
    else
        waveCell={wv};
    end
else
    error('baseline: 1st argument must be a wave,wave name, or cell array of wave names');
end

for waveCounter=1:length(waveCell)
	waveName=waveCell{waveCounter};
	data=get(waveName,'data');
	if (numdims(data)<2)
        baseline=mean2(data(1:n));
        data=data-baseline;
        setWave(waveName,'data',[data]);
	else
		error('baseline: wave must be one-dimensional.');
	end
end
