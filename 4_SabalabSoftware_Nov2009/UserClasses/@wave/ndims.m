function [varargout] = ndims(wv1,wv2)

% overload ndims for waves...

% This function computes the dimensions of a wave...
% Uhnlike the built in matlab function ndims, this function
% adopts standard mathematical definitions.
% Thus, a scalar is ndims = 0, a vector is ndims = 1, 
% and array is ndims = 2, and so on.
%

a = size(wv1);
ndims=length(a);

if ~isempty(find(a==1))     % If there are singelton dimensions....
    numberOfOnes = length(find(a==1));
    ndims=ndims-numberOfOnes;
end

if ~isempty(find(a==0))     % If there are singelton dimensions....
    numberOfOZeros = length(find(a==0));
    ndims=ndims-numberOfOZeros;
end


if nargout==1
    varargout{1}=ndims;
else
    display(ndims);
end

