function val=getWaveUserDataField(wv, field)
% This function looks at the userData for the wave wv
% Then, if it is a structure (the default), it will get the field
% 'field' and output its value.


if nargin ~= 2
    error('getWaveUserDataField: A wave and a field must be included in the arguments.');
end

if iswave(wv)
	if ~ischar(wv)
		name=inputname(1);
    else
        name=wv;
    end
else
	error('getWaveUserDataField: Wave name required as input #1');
end

if ~ischar(field)
	error('getWaveUserDataField: Field name required as input #2');
end

ud=getWave(name, 'UserData');

val=[];
if isa(ud, 'struct') | isempty(ud)  % IS it a structure
	if isfield(ud, field)
		val=getfield(ud, field);
	end
end
