function varargout=plotr(wv,varargin)
% Same as plot, but reverses the axis...pltos Xscale along y, and data along x...
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
%If you are using plot(x,y,z,...) then the first field of names is blank, indicating
% You used the scale property of that wave as the XData.
% The wv.plot gets updated for each wave with the same handle.
%

if nargin == 0 
    error('plotr: must supply at least one wave to plot in input cellstr');
end

if iscellstr(wv)
    if all(iscellwave(wv))
        waveCell=wv;
    else
        error('plotr: 1st argument must be a wave,wave name, or cell array of wave names');
    end
elseif iswave(wv)
    if ~ischar(wv)
        waveCell = {inputname(1)};
    else
        waveCell={wv};
    end
else
    error('plotr: 1st argument must be a wave,wave name, or cell array of wave names');
end

property_argin = varargin;
[ax,property_argin]=getValOfParam(property_argin,'axes');
if ~isempty(ax)  %No axes passed
    disp('plotr : ignoring axes parameter for plotxy. Use append to specify an axes.');
end

figureName='';
allhandles=[];
for counter = 1:length(waveCell)
    waveName = waveCell{counter};
    if ~iswave(waveName)
        error('plotr: All inputs must be of class wave.');
    else
        wv=get(waveName);
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
    UserData.name = {waveName '' ''};
    UserData.timeStamp = [wv.timeStamp 0 0];
    if isempty(wv.data)
        wv.data=NaN;
    end
	if size(wv.data,1)>1
	    h=plot(wv.data(1,:), makeXData(wv), 'Parent', ax, 'UserData', UserData, 'tag', waveName);
	else
		h=plot(wv.data, makeXData(wv), 'Parent', ax, 'UserData', UserData, 'tag', waveName);
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
        set(h,property_argin{counter},val);
    else
        disp(['plotr: ignoring reserved setting for prop: ' property_argin{counter}]);
    end
    counter=counter+2;
end
set(f, 'Name', figureName);
rescaleAxis(ax);

if nargout==1
    varargout{1}=allhandles;
end

