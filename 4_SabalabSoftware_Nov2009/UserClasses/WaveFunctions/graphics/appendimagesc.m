function varargout=appendimagesc(wv,varargin)
% Adds wave as image to axes plots...current axes is default, if it exists.
% wv must be a wave, wave naem (char), or cell arrray of wave names...
% USer can specify one, or one will be created.
% flag = 0 or no flag means dont change the figure properties, which is
% useful for GUI plots.
% 
% Flags:  newAxes: make a new axes for each wave passed in (set if axes = 0)
%         updateFig: updatw figure with wave properties on loading

if iscellstr(wv)
	if all(iscellwave(wv))
		waveCell=wv;
	else
		error('append: 1st argument must be a wave,wave name, or cell array of wave names');
	end
elseif iswave(wv)
	if ~ischar(wv)
		waveCell = {inputname(1)};
	else
		waveCell={wv};
	end
else
	error('append: 1st argument must be a wave,wave name, or cell array of wave names');
end

property_argin = varargin;
[ax,newAxes,f,allAx,property_argin]=getAxesInfo(property_argin);

if ~newAxes
    set(ax, 'NextPlot', 'add');
    f=get(ax,'Parent');
elseif istype(f,'figure')
    set(f,'ColorMap',colormap(gray));
end

[updateFig,property_argin]=getValOfParam(property_argin,'updateFig');
if ~isempty(updateFig) &  updateFig == 1
    set(get(ax, 'Parent'),'Color', 'w', 'DoubleBuffer', 'on', 'CloseRequestFcn', 'plotWaveDeleteFcn','KeyPressFcn','plotKeyPressFcn',...
         'WindowButtonDownFcn','plotButtonDwnFcn','WindowButtonUpFcn','plotButtonUpFcn');
end

allhandles=[];
for waveCounter=1:length(waveCell)
    if newAxes
        UserData.autoScale=1;
        ax=axes('Parent', f, 'Color', 'None', 'NextPlot', 'add', 'UserData', UserData, ...
            'XLimMode', 'auto', 'YLimMode', 'auto', 'Tag', ['Axis' num2str(allAx+1)]);
        allAx=allAx+1;
        setWaveContextMenu(ax);
    end 
	waveName=waveCell{waveCounter};
	UserData=[];
	UserData.name = {'' '' waveName};
	UserData.timeStamp = [0 0 get(waveName, 'timeStamp')];
	h=imagesc(get(waveName, 'data'), 'Parent', ax, 'UserData', UserData,'XData', makeXData(waveName), 'YData', makeYData(waveName), 'Tag', waveName);
	setWaveContextMenu(h);
    allhandles=[allhandles h];
    setWave(waveName, 'plot', [get(waveName, 'plot') h]);
	if strcmpi(get(get(ax, 'Parent'), 'NumberTitle'),'on')
		set(get(ax, 'Parent'), 'Name', [get(get(ax, 'Parent'), 'Name') ' ' waveName]);
	end
    if newAxes
        rescaleAxis(ax,'yfraction',0);
    end
end

% Parse input parameter pairs and rewrite values.
counter=1;
while counter+1 <= length(property_argin)
    if ~any(strcmpi(property_argin{counter},{'CData','XData','YData','UserData','Parent','Tag'}))
        val = property_argin{counter+1};
        set(allhandles,property_argin{counter},val);
    else
        disp(['appendimage: ignoring reserved setting for prop: ' property_argin{counter}]);
    end
    counter=counter+2;
end

if nargout==1
    varargout{1}=allhandles;
end

