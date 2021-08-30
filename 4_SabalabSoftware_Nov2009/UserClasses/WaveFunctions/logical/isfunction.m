function out = isfunction(input)
% Tries to determine if the string represents a valid matlab function or not.
% Also checks if it is a keyword.=
out=[];
if ischar(input)
	if exist(input) == 2 | exist(input) == 5 | iskeyword(input)
		out=1;
	else
		out=0;
	end
elseif iscellstr(input)
	for i=1:length(input)
		if exist(input{i}) == 2 | exist(input{i}) == 5 | iskeyword(input{i})
			out=[out 1];
		else
			out=[out 0];
		end
	end
end
out=logical(out);

