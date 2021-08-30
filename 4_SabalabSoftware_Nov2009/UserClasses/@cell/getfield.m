function val=getfield(wv, field)
% This function looks at the userData for the wave wv
% Then, if it is a structure (the default), it will get the field
% 'field' and output its value.

if ~all(iswave(wv))
    error('getfield: input must be a wave, wavename, or cell array of names');
end

if nargin < 2
    error('getfield: A wave and a field must be included in the arguments.');
end

if ~ischar(field)
    error('getfield: Field name required as input #2');
end

ud=getWave(wv, 'UserData');
if ~iscell(ud)
    ud={ud};
end
for waveCounter=1:length(ud)
    if isfield(ud{waveCounter}, field)
        val{waveCounter}=getfield(ud{waveCounter}, field);
    else
        error(['getfield: invalid field name for wave: ' wv{waveCounter}]);
    end
end

%if only one param, do not pass out a cell array, pass out waht is in the cell array.
if length(val) == 1
    val=val{1};
end