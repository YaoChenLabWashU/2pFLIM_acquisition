function varargout=append(wv,varargin)
% Adds wave to axes plots...current axes is default, if it exists.
% wv must be a wave, wave naem (char), or cell arrray of wave names...
% USer can specify one, or one will be created.
% flag = 0 or no flag means dont change the figure properties, which is useful for GUI plots.
% will output a vector of handles to new plots if 
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
end

[updateFig,property_argin]=getValOfParam(property_argin,'updateFig');
if ~isempty(updateFig) &&  (updateFig == 1)
    set(get(ax, 'Parent'),'Color', 'w', 'DoubleBuffer', 'on', 'CloseRequestFcn', 'plotWaveDeleteFcn','KeyPressFcn','plotKeyPressFcn',...
        'WindowButtonDownFcn','plotButtonDwnFcn','WindowButtonUpFcn','plotButtonUpFcn');
end

allhandles=[];
for waveCounter=1:length(waveCell)
    if newAxes
        UserData.autoScale=defaultAxisScaleMode;
        ax=axes('Parent', f, 'Color', 'None', 'NextPlot', 'add', 'UserData', UserData, ...
            'XLimMode', 'auto', 'YLimMode', 'auto', 'Tag', ['Axis' num2str(allAx+1)]);
        allAx=allAx+1;
        setWaveContextMenu(ax);
    end 
    waveName=waveCell{waveCounter};
    wv=getWave(waveName);
    UserData=[];
    UserData.name = {'' waveName ''};
    UserData.timeStamp = [0 wv.timeStamp 0];
    if isempty(wv.data)
        wv.data=NaN;
	    h=plot(nan, wv.data, 'Parent', ax, 'UserData', UserData, 'tag', waveName);
	else
	    h=plot(makeXData(waveName), wv.data, 'Parent', ax, 'UserData', UserData, 'tag', waveName);
	end
    setWaveContextMenu(h);
    allhandles=[allhandles h];
    setWave(waveName, 'plot', [wv.plot h]);
    if strcmpi(get(get(ax, 'Parent'), 'NumberTitle'),'on')
        set(get(ax, 'Parent'), 'Name', [get(get(ax, 'Parent'), 'Name') ' ' waveName]);
    end
%    if newAxes		% BSMOD always do below
	 rescaleAxis(ax, 'reorder', 1);
%    end
end

% Parse input parameter pairs and rewrite values.
counter=1;
while counter+1 <= length(property_argin)
    if ~any(strcmpi(property_argin{counter},{'XData','YData','UserData','Parent','Tag'}))
        val = property_argin{counter+1};
        set(allhandles,property_argin{counter},val);
    else
        disp(['append: ignoring reserved setting for prop: ' property_argin{counter}]);
    end
    counter=counter+2;
end

if nargout==1
    varargout{1}=allhandles;
end

