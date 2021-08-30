function reshuffleAxisHandles(axishandle)
% This function rearranges the order of pltos and imaegs on an axis
% so that the image is displayed on the bottom...that wy the pltos can be seen.

if nargin == 0	% No inputs...look for GCA
    a=findobj('Type', 'axes');  % Are there any axes?
    if ~isempty(a)              
        ax=gca;
    else
        error('No Waves on this plot');
    end
elseif nargin==1	% axis handle...check
    if istype(axishandle,'axes')
        ax=axishandle;
    else      
        error('reshuffleAxisHandles: invalid axes handle.');
    end
else
    error('reshuffleAxisHandles: too many inputs')
end

a = get(ax, 'Children');
type = get(a, 'type');

top=[];
bottom=[];
neither=[];

if iscell(type)
    for i = 1:length(type)
        if strcmp(type{i}, 'image')
            bottom = [bottom; a(i)];    % make array of handles for the bottom
        elseif strcmp(type{i}, 'line')  
            top = [top ; a(i)];     % lines go on top...
        else
            neither = [neither; a(i)];
        end
    end
else
    top=a;  % only one hter....
end

set(ax, 'Children', [top;neither;bottom]);
