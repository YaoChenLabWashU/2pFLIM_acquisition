function [varargout] = mtimes(wv1,wv2)
% Overloads plus operation 
% Multiplies Waves wv1 and wv2 point by point

a = double(wv1);
b = double(wv2);
out = a.*b;

if nargout==1
    varargout{1}=out;
end
