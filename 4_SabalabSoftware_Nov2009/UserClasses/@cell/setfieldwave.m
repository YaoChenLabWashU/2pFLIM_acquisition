function setfieldwave(wv, field, value)
% This function looks at the userData for the wave wv
% Then, if it is a structure (the default), it will add the field
% 'field' to it, with the value value
% If field already exists, it changes its value.

if ~all(iswave(wv))
    error('setfield: input must be a wave, wavename, or cell array of names');
end

if nargin < 2
    error('setfield: A wave and a field must be included in the arguments.');
end

if ~ischar(field)
    error('setfield: Field name required as input #2');
end

ud=getWave(wv, 'UserData');
if ~iscell(ud)
    ud={ud};
end
for waveCounter=1:length(ud)
    ud{waveCounter}=setfield(ud{waveCounter}, field, value);
    setWave(wv{waveCounter}, 'UserData', ud{waveCounter});
end
