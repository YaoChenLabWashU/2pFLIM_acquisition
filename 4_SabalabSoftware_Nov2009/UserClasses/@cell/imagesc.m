function varargout=imagesc(in,varargin)
% Overloaded method for class cell where the input is a
% string wave name.
% new image function
% does not set colormap.  use imagesc.

if nargin == 0 
    error('@cell/image: must supply at least one wave to plot in input cellstr');
end

if ~iscellstr(in)
    error('@cell/image: input to plot must be a cell array of wave names.');
end

property_argin = varargin;
[ax,property_argin]=getValOfParam(property_argin,'axes');
if ~isempty(ax)  %No axes passed
    disp('@cell/image : ignoring axes parameter for plotxy. Use append to specify an axes.');
end

figureName='';
allhandles=[];
for counter = 1:length(in)
    waveName = in{counter};
    if ~iswave(waveName)
        error('@cell/image: All inputs in cellstr must be of class wave.');
    else
        wv=get(waveName);
    end
    if counter == 1
        f=figure('Color', 'w', 'DoubleBuffer', 'on', 'CloseRequestFcn', 'plotWaveDeleteFcn','KeyPressFcn','plotKeyPressFcn',...
              'WindowButtonDownFcn','plotButtonDwnFcn','WindowButtonUpFcn','plotButtonUpFcn','Name', waveName);
        UserData.autoScale=1;
        colormap(gray);
        allAx=findobj(f,'Type','axes');
        ax=axes('Parent', f, 'Color', 'None', 'NextPlot', 'add', 'UserData', UserData, ...
            'XLimMode', 'auto', 'YLimMode', 'auto', 'Tag', ['Axis' num2str(length(allAx)+1)]);
        figureName=[waveName];
        setWaveContextMenu(ax);
    end
    UserData=[];
    UserData.name = {'' '' waveName} ;
    UserData.timeStamp = [ 0 0 wv.timeStamp];
    h=imagesc('CData', wv.data, 'Parent', ax, 'UserData', UserData,'XData', makeXData(wv), 'YData', makeYData(wv), 'Tag', waveName);
    setWaveContextMenu(h);
    allhandles=[allhandles h];
    % Parse input parameter pairs and rewrite values. 
    setWave(waveName, 'plot', [wv.plot h]);
    % Parse input parameter pairs and rewrite values.
end
rescaleAxis(ax,'yfraction',0);

% Parse input parameter pairs and rewrite values.
counter=1;
while counter+1 <= length(property_argin)
    if ~any(strcmpi(property_argin{counter},{'CData','XData','YData','UserData','Parent','Tag'}))
        val = property_argin{counter+1};
        set(allhandles,property_argin{counter},val);
    else
        disp(['@cell/image: ignoring reserved setting for prop: ' property_argin{counter}]);
    end
    counter=counter+2;
end

if nargout==1
    varargout{1}=allhandles;
end
