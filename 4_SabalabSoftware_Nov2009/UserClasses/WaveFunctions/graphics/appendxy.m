function varargout=appendxy(name1, name2, varargin)
% Adds xyplot to the wave to axes plots...current axes is default, if it exists.
% wv must be a wave.
% User can specify one, or one will be created.
% % flag = 0 or no flag means dont change the figure properties, which is useful for GUI plots.

if nargin < 2
    error('plotxy: must supply 2 waves to plot.  USe plot(wv1,wv2, ..) to plot waves normally (vs wv.scale).');
end

if iswave(name1) & iswave(name2)
    if ~ischar(name1)
        name1 = inputname(1);
    end
    
    if ~ischar(name2)
        name2 = inputname(2);
    end
else
    error('appendxy: must supply valid waves as inputs');
end

property_argin = varargin;
[ax,newAxes,f,allAx,property_argin]=getAxesInfo(property_argin);


if ~newAxes
    set(ax, 'NextPlot', 'add');
    f=get(ax,'Parent');
else
    UserData.autoScale=1;
    ax=axes('Parent', f, 'Color', 'None', 'NextPlot', 'add', 'UserData', UserData, ...
        'XLimMode', 'auto', 'YLimMode', 'auto', 'Tag', ['Axis' num2str(allAx+1)]);
    allAx=allAx+1;
    setWaveContextMenu(ax);
end 
    
[updateFig,property_argin]=getValOfParam(property_argin,'updateFig');
if ~isempty(updateFig) &  updateFig == 1
    set(f,'Color', 'w', 'DoubleBuffer', 'on', 'CloseRequestFcn', 'plotWaveDeleteFcn','KeyPressFcn','plotKeyPressFcn',...
        'WindowButtonDownFcn','plotButtonDwnFcn','WindowButtonUpFcn','plotButtonUpFcn');
end
wv1=getWave(name1);
wv2=getWave(name2);

size1=waveSize(name1);
size2=waveSize(name2);
UserData.name = {name1 name2 ''};
UserData.timeStamp = [wv1.timeStamp wv2.timeStamp 0];
temp_plotMinLen= min(size1(2), size2(2));
if isempty(wv1.data)
    wv1.data=NaN;
end
if isempty(wv2.data)
    wv2.data=NaN;
end
h=plot(wv1.data(1,1:temp_plotMinLen),wv2.data(1,1:temp_plotMinLen), 'Parent', ax, 'UserData', UserData, 'tag', [name1 ' vs. ' name2]);
setWaveContextMenu(h);
setWave(name1, 'plot', [wv1.plot h]);
if ~strcmp(name1, name2)
    setWave(name2, 'plot', [wv2.plot h]);
end
if strcmpi(get(f, 'NumberTitle'),'on')
    set(f, 'Name', [get(f, 'Name') ' ' name1 name2]);
end
if newAxes
    rescaleAxis(ax);
end

% Parse input parameter pairs and rewrite values.
counter=1;
while counter+1 <= length(property_argin)
    if ~any(strcmpi(property_argin{counter},{'XData','YData','UserData','Parent','Tag'}))
        val = property_argin{counter+1};
        set(h,property_argin{counter},val);
    else
        disp(['append: ignoring reserved setting for prop: ' property_argin{counter}]);
    end
    counter=counter+2;
end

if nargout==1
    varargout{1}=h;
end
