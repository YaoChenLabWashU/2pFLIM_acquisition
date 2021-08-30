function out=istype(handle,type)
% Returns a 1 if the handle specified is the type listed.
% returns 0 if it is not a handle or is not the type specified
% can be used like ishandle with a specific type to compare with also.
out=0;
if nargin ~=2
	error('istype: Must supply 2 inputs, a handle and a type');
end

if ~ischar(type)
	error('istype: first input must be a handle to a graphics object and the second a string.');
end

if any(~ishandle(handle))
	return
elseif strcmp(type, get(handle,'type'))
	out=1;
end




