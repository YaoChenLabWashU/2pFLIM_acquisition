function [varargout]  = isequalsize(wv1,wv2)
% This function compares the size fo 2 waves.
% if they are the same, it returns 1.
% If they are different, it returns 0

a = size(wv1);
b = size(wv2);
out = ~any(a~=b);
    
if nargout==1
    varargout{1}=out;
else
    display(out);
end
