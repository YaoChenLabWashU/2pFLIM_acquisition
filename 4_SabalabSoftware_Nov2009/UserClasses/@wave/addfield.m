function addfield(wv, field, value)
% This function looks at the userData for the wave wv
% Then, if it is a structure (the default), it will add the field
% 'field' to it, with the value value
% If field already exists, it changes its value.

if nargin < 2
    error('setfield: A wave and a field must be included in the arguments.');
end

if ~iswave(wv)
    error('setfield: Wave name required as input #1');
end

if ~ischar(field)
    error('getfield: Field name required as input #2');
end

if nargin < 3
    value=[];
end

addfield(inputname(1),field,value);
