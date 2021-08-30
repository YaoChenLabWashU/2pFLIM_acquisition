function varargout=plot(in,varargin)
% Overloaded method for class cellstr where the strings in the cell
% array are wave names

if nargin == 0 
    error('plot: must supply at least one wave to plot in input cellstr');
end

if ~iscellstr(in)
    error('plot: input to plot must be a cell array of wave names.');
end

property_argin = varargin;
[ax,property_argin]=getValOfParam(property_argin,'axes');
if ~isempty(ax)  %No axes passed
    disp('@cell/plot : ignoring axes parameter for plotxy. Use append to specify an axes.');
end

figureName='';
allhandles=[];
for counter = 1:length(in)
    waveName = in{counter};
    if ~iswave(waveName)
        error('@cell/plot: All inputs in cellstr must be of class wave.');
    else
        wv=getWave(waveName);
    end

    if counter == 1
        f=figure('Color', 'w', 'DoubleBuffer', 'on', 'CloseRequestFcn', 'plotWaveDeleteFcn','KeyPressFcn','plotKeyPressFcn',...
              'WindowButtonDownFcn','plotButtonDwnFcn','WindowButtonUpFcn','plotButtonUpFcn');
        colormap(gray);
        UserData.autoScale=defaultAxisScaleMode;
        allAx=findobj(f,'Type','axes');
        ax=axes('Parent', f, 'Color', 'None', 'NextPlot', 'add', 'UserData', UserData, ...
            'XLimMode', 'auto', 'YLimMode', 'auto', 'Tag', ['Axis' num2str(length(allAx)+1)]);
        setWaveContextMenu(ax);
    end
    figureName=[figureName ' ' waveName];
    UserData=[];
    UserData.name = {'' waveName ''};
    UserData.timeStamp = [0 wv.timeStamp 0];
    if isempty(wv.data)
        wv.data=NaN;
    end
	if size(wv.data,1)>1
	    h=plot(makeXData(waveName), wv.data(1,:), 'Parent', ax, 'UserData', UserData, 'tag', waveName);
	else		
	    h=plot(makeXData(waveName), wv.data, 'Parent', ax, 'UserData', UserData, 'tag', waveName);
	end
    setWaveContextMenu(h);
    allhandles=[allhandles h];
    % Parse input parameter pairs and rewrite values. 
    setWave(waveName, 'plot', [wv.plot h]);
end

% Parse input parameter pairs and rewrite values.
counter=1;
while counter+1 <= length(property_argin)
    if ~any(strcmpi(property_argin{counter},{'XData','YData','UserData','Parent','Tag'}))
        val = property_argin{counter+1};
        set(allhandles,property_argin{counter},val);
    else
        disp(['@char/plot: ignoring reserved setting for prop: ' property_argin{counter}]);
    end
    counter=counter+2;
end
set(f, 'Name', figureName);
rescaleAxis(ax, 'reorder', 1);		% BSMOD

if nargout==1
    varargout{1}=allhandles;
end
