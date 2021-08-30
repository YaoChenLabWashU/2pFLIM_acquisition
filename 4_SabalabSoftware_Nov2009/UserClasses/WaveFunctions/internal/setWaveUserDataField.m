function setWaveUserDataField(wv, field, value)
% This function looks at the userData for the wave wv
% Then, if it is a structure (the default), it will add the field
% 'field' to it, with the value value
% If field already exists, it changes its value.

if nargin < 3
    error('setWaveUserDataField: A wave, field, and value must be included in the arguments.');
end

if iswave(wv)
	if ~ischar(wv)
		wv=inputname(1);
	end
else
	error('setWaveUserDataField: Wave name required as input #1');
end

if ~ischar(field)
	error('setWaveUserDataField: Field name required as input #2');
end

ud=getWave(wv, 'UserData');

if isstruct(ud) | isempty(ud)  % IS it a structure
	ud=setfield(ud, field, value);
else
	error('setWaveUserDataField: UserFields is not a structure.');
end
setWave(wv, 'UserData', ud);