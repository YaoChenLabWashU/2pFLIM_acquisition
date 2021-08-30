function [varargout] = plus(wv1,wv2)
% Overloads plus operation 
% Adds Waves wv1 and wv2

out = wv1.data + wv2.data;

if nargout==1
    varargout{1}=out;
end
