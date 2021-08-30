function expandAxes(handle,varargin)
% expands waves on axes to new axes in figure spalyed axes 

if nargin < 1
    handle=gca;
elseif ~istype(handle,'axes')
    error('expandAxes: Must supply a figure handle');
end
f=get(handle,'Parent');
allAx=length(findobj(f,'type','axes'));
plotarray=[findobj(handle,'type','line') findobj(handle,'type','image')];
plotarray=unique(plotarray);

if isempty(plotarray)
    return
else
    for objCounter=2:length(plotarray)
        UserData.autoScale=1;
        ax=axes('Parent', f, 'Color', 'None', 'NextPlot', 'add', 'UserData', UserData, ...
            'XLimMode', 'auto', 'YLimMode', 'auto', 'Tag', ['Axis' num2str(allAx+1)]);
        setWaveContextMenu(ax);
        set(plotarray(objCounter),'Parent',ax);
        rescaleAxis(ax);
    end
end

tilestyle='Tile';
% Parse input parameter pairs and rewrite values.
counter=1;
while counter+1 <= length(varargin)
    eval([varargin{counter} '=''' (varargin{counter+1}) ''';']);
    counter=counter+2;
end
eval(['splayAxis' tilestyle '(f);']);




