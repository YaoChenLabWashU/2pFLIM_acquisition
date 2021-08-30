function [varargout] = times(wv1,wv2)
% Overloads plus operation 
% Multiplies Waves wv1 and wv2 point by point

out = wv1.data.*wv2.data;

if nargout==1
    varargout{1}=out;
end
