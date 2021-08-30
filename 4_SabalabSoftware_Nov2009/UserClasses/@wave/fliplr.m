function varargout = fliplr(wv)
%FLIPLR Overloaded Flip matrix in left/right direction for class wave.
%   FLIPLR(wv) returns a double array with row preserved and columns flipped
%   in the left/right direction.
%   
%   wv= 1 2 3     becomes  3 2 1
%

out=fliplr(wv.data);

if nargout==1
    varargout{1}=out;
end
