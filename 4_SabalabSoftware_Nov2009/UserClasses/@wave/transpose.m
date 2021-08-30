function [varargout] = transpose(wv1)
% Overloads reverse operation 
% Adds Waves wv1 and wv2

out=wv1.data';

if nargout==1
    varargout{1}=out;
end
