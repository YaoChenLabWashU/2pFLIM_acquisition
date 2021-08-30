function varargout=plotxy(name1, name2, varargin)
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
    error('plotxy: must supply valid waves as inputs');
end

property_argin = varargin;
[ax,property_argin]=getValOfParam(property_argin,'axes');
if ~isempty(ax)  %No axes passed
    disp('plotxy : ignoring axes parameter for plotxy. Use append to specify an axes.');
end

f=figure('Color', 'w', 'DoubleBuffer', 'on', 'CloseRequestFcn', 'plotWaveDeleteFcn','KeyPressFcn','plotKeyPressFcn',...
      'WindowButtonDownFcn','plotButtonDwnFcn','WindowButtonUpFcn','plotButtonUpFcn');
colormap(gray);
UserData.autoScale=defaultAxisScaleMode;
allAx=findobj(f,'Type','axes');
ax=axes('Parent', f, 'Color', 'None', 'NextPlot', 'add', 'UserData', UserData, ...
    'XLimMode', 'auto', 'YLimMode', 'auto', 'Tag', ['Axis' num2str(length(allAx)+1)]);
setWaveContextMenu(ax);
wv1=get(name1);
wv2=get(name2);

size1=waveSize(name1);
size2=waveSize(name2);
UserData.name = {name1 name2 ''};
UserData.timeStamp = [wv1.timeStamp wv2.timeStamp 0];

if isempty(wv1.data)
    data1=NaN;
else
	data1=wv1.data;
end
if isempty(wv2.data)
	data2=nan;
else
	data2=wv2.data;
end

temp_plotMinLen= min(length(data1), length(data2));

h=plot(data1(1,1:temp_plotMinLen), data2(1,1:temp_plotMinLen), 'Parent', ax, 'UserData', UserData, 'tag', [name1 ' vs. ' name2]);
setWaveContextMenu(h);
setWave(name1, 'plot', [wv1.plot h]);
if ~strcmp(name1, name2)
    setWave(name2, 'plot', [wv2.plot h]);
end
if get(f, 'NumberTitle')=='on'
    set(f, 'Name', [get(f, 'Name') ' ' name2 ' vs ' name1]);
end
rescaleAxis(ax, 'reorder', 1);

% Parse input parameter pairs and rewrite values.
counter=1;
while counter+1 <= length(property_argin)
    if ~any(strcmpi(property_argin{counter},{'XData','YData','UserData','Parent','Tag'}))
        val = property_argin{counter+1};
        set(h,property_argin{counter},val);
    else
        disp(['plotxy: ignoring reserved setting for prop: ' property_argin{counter}]);
    end
    counter=counter+2;
end

if nargout==1
    varargout{1}=h;
end
