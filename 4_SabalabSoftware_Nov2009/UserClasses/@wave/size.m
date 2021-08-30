function [varargout]= SIZE(wv,dim)
% overloading the size operatiopn for waves...
% outputs the size of the data in the array.
% By default, size(wave) always retuirns [1 1]..
% That is not useful.


out=size(wv.data);

if nargin == 2
    switch dim
    case 1
        out =out(dim);    
    case 2
        out = out(dim);
    otherwise
        error('@wave/size: dim must be either 1 or 2.');
    end
end
    
if nargout==1
    varargout{1}=out;
else
    display(out);
end
