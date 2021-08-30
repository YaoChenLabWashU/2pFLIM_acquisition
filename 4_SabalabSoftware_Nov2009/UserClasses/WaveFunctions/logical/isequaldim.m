function [varargout] = isequaldim(wv1,wv2)
% This function compares the dimensions of 2 waves...
% if they are the same, it returns 1.
% If they are different, it returns 0

a = size(wv1);
b = size(wv2);

if isempty(find(a==1)) & isempty(find(b==1))    % both 2D waves...
    out =1;
elseif isempty(find(a==1)) & ~isempty(find(b==1)) 
    out=0;
elseif ~isempty(find(a==1)) & isempty(find(b==1))  
    out=0;
elseif ~isempty(find(a==1)) & ~isempty(find(b==1))  
    out=1;
end

    
if nargout==1
    varargout{1}=out;
else
    display(out);
end
