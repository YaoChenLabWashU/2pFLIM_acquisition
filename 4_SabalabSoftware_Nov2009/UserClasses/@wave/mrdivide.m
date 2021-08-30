function [varargout] = mrdivide(wv1,wv2)
% Overloads plus operation 
% Adds Waves wv1 and wv2

a = double(wv1);
b = double(wv2);
out = a./b;

if nargout==1
    varargout{1}=out;
end
