function [varargout] = ctranspose(wv1)
% Overloads reverse operation 
% Adds Waves wv1 and wv2

a = double(wv1);
out=a';

if nargout==1
    varargout{1}=out;
end
