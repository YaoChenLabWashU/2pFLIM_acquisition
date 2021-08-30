function val=getfield(wv, field)
% This function looks at the userData for the wave wv
% Then, if it is a structure (the default), it will get the field
% 'field' and output its value.
if nargin ~= 2
    error('getfield: A wave and a field must be included in the arguments.');
end

if ~iswave(wv)
    error('getfield: Wave name required as input #1');
end

if ~ischar(field)
    error('getfield: Field name required as input #2');
end

val=eval(['wv.' field]);

