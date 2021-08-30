function [varargout] = mean(wv1)
% Overloads mean operation 
% outputs mean value of a wave.
data=get(wv1,'data');
out = mean(data);
if nargout==0
    disp(' ');
    disp('ans = ');
    disp(' ')
    disp(out);
elseif nargout==1
    varargout{1}=out;
end