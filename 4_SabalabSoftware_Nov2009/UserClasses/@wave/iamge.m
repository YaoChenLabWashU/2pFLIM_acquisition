function image(varargin)
% Overloaded method for class wave where the input is a
% wave.
% new image function
% does not set colormap.  use imagesc.

if nargin < 1
    error('@wave/image: must supply at least one wave to plot');
end

for counter = 1:length(varargin)
	waveName{counter} = inputname(counter);
end

image(waveName);
