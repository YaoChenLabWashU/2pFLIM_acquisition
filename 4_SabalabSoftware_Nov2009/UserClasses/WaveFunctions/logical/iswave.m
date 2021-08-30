function out=iswave(wv)
% IS this sa wave? Accepts string inputs.
% Accepts cell array of strings as input.
% now ignores empty arrays and strings with spaces in them

if ischar(wv) %& ~isempty(wv) & isempty(strfind(wv,' '))
% 	if isfunction(wv)
% 		out=0;
% 		disp(['iswave: ' wv ' is a keyword or function']);
% 		return
% 	end
	if ~evalin('base',['exist(''' wv ''')==1;']) 
		out=0;
	else
		out=evalin('base',['isa(' wv ',''wave'');']); 
	end
elseif iscellstr(wv)
	out=iscellwave(wv);
else
	out = isa(wv,'wave');
end
