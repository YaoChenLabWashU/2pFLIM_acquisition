function out=waveSize(wavename)
out=[];
if all(iswave(wavename))
    if ischar(wavename) 
        out=size(getWave(wavename,'data'));
    elseif iscellstr(wavename)
        out=[cellfun('size',getWave(wavename,'data'),1)' cellfun('size',getWave(wavename,'data'),2)'];
    else
        out=size(wavename.data);
    end
elseif isstruct(wavename)
    if isfield(wavename, 'data')
        out=size(wavename.data);
    else
        error('waveSize : expected wave or wavenane as input');
    end
else    
    error('waveSize : expected wave or wavenane as input');
end