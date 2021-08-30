function [varargout] = MEAN(wv1)
% Overloads mean operation 
% outputs mean value of a wave.

out = mean(wv1.data);

if nargout==0
    disp(' ');
    disp('ans = ');
    disp(' ')
    disp(out);
elseif nargout==1
    varargout{1}=out;
end