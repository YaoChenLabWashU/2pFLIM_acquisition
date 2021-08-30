function [varargout] = mpower(wv1,power)
% Overloads plus operation 
% Adds Waves wv1 and wv2

a = double(wv1);
out = a.^power;

if nargout==1
    varargout{1}=out;
end
