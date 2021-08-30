function plot(varargin)
% Overload for class wave
% plots wave in a new figure window.
% plot(a,b,c,...) plots all these waves on the same figure.
% All inputs must be waves.
%
% UserData fields contain cell arrays or regular arrays of names, and timeStamps
% name is a field containing the char name of each wave, and the position is the 
% location of how it is used in a graph.  
%
% Example: UserData.name =  {'wv1' 'wv2' '' } indicates that there is no Z data and that 
% the XData of the plot comes from the wave 'wv1' and the YData comes from the
% wave 'wv2'.
% 
% If you are using plot(x,y,z,...) then the first field of names is blank, indicating
% You used the scale property of that wave as the XData.
% The wv.plot gets updated for each wave with the same handle.
%

if nargin < 1
    error('@wave/plot: must supply at least one wave to plot');
end

for counter = 1:length(varargin)
	waveName{counter} = inputname(counter);
end

plot(waveName);
