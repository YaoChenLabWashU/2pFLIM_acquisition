function [varargout] = numdims(in)
% Alos works for any object with a valid size function.

% overload ndims for waves...
% This function computes the dimensions of a wave...
% Uhnlike the built in matlab function ndims, this function
% adopts standard mathematical definitions.
% Thus, a scalar is ndims = 0, a vector is ndims = 1, 
% and array is ndims = 2, and so on.
%
% The maximum number of dimensions is the number of elements in the size output: length(size(in)).
% Everyone of these that is 0 needs to be removed. we find the number of zeros 
% using the trick that a==1 returns an array of ones and zeros where this was true,
% so we find this array and the sum accross its columns is the number of ones in the size: sum(size(in)==1)
% We then subtract to get the correct number of dimensions.

if iswave(in)
    if ischar(in)
        sz=size(get(in,'data'));
    else
        sz=size(get(inputname(1),'data'));
    end
else
    sz=size(in);
end

ndims=length(sz(sz~=1 & sz~=0));

if nargout==1
    varargout{1}=ndims;
else
    disp(' ');
    disp('ans = ');
    disp(' ');
    disp(ndims);
end

