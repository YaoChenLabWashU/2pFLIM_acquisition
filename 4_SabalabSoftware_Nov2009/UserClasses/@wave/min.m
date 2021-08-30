function [varargout] = min(wv1)
% Overloads max operation 
% outputs maximum value of a wave.

[out,val] = min(wv1.data);
if nargout==0
    disp(' ');
    disp('ans = ');
    disp(' ')
    disp(out);
elseif nargout==1
    varargout{1}=out;
elseif nargout==2
    varargout{1}=out;
    varargout{2}=val;
end