function setPlotProps(wv, varargin)
% This function will update the plot properties for a given wave on the current axis.
% If an axis is specified, it will look on that axis first.
% The axis must be the second in the inptu list and the first in the varargins...
% If no accerss is specified and the current axis does not contain the wave, 
% then nothing happens.
% 
% Now takes axes specifically as an input parameter pair like setPlotProp(wave,'axes',handles,...)
%
% Also saccepts char as waveNames,.,,
% Common Properties include:
% 'Color', [r g b] (or 'red', 'blue', 'green')
% 'LineStyle' , {-} | -- | : | -. | none
% 'LineWidth',  scalar
% 'Marker', {'d', '+', 'o', ...}
% Now updated....
% Others listed uncder help for line properties.


if nargin < 3
    error('setPlotProps: inout a wave, parameter string, and value.')
end

%Parse the inputs....
if iscellstr(wv)
    if all(iscellwave(wv))
        waveCell=wv;
    else
        error('setPlotProps: 1st argument must be a wave,wave name, or cell array of wave names');
    end
elseif iswave(wv)
    if ~ischar(wv)
        waveCell = {inputname(1)};
    else
        waveCell={wv};
    end
else
    error('setPlotProps: 1st argument must be a wave,wave name, or cell array of wave names');
end

%March through each wave in cell array
for waveCounter=1:length(waveCell)
    waveName=waveCell{waveCounter};
    wv=getWave(waveName);
    
%     % Check if wave contains invalid handles....
%     removebadPlots(waveName);
    
    % Parse input parameter pairs and rewrite values.
    property_argin = varargin;
    [ax,newAxes,f,allAx,property_argin]=getAxesInfo(property_argin);

    figHandle=get(ax,'Parent');

    handles = findobj(ax, 'type', 'line');	% All plots....
    userdata = get(handles, 'UserData');	% Look in UserData.        
    if ~iscell(userdata)
        userdata={userdata};
    end
    
    % Figure out which handles to change.
    handlesToChange=[];
    for i = 1:length(handles)	
        if isfield(userdata{i}, 'name')
            if strcmp(userdata{i}.name{2}, waveName)	% This is the YData....so change props
                handlesToChange = [handlesToChange handles(i)];
            end
        end
    end
    
    %Parse the remaining inputs...
    while length(property_argin) >= 2
        prop = property_argin{1};
        val = property_argin{2};
        property_argin = property_argin(3:end);
        if strcmp(prop, 'XLabel') | strcmp(prop, 'YLabel') |  strcmp(prop, 'Title')	% These are axis properties, not plot properties...
            set(get(ax,prop),'String',val);	
        elseif strcmp(prop, 'XLim') | strcmp(prop, 'YLim') | strcmp(prop, 'YLim') 
            set(ax,prop,val);	
        elseif strcmp(prop, 'Position') | strcmp(prop, 'Name') | strcmp(prop, 'DoubleBuffer') 
            set(figHandle,prop,val);
        else
            set(handlesToChange, prop, val);
        end
    end
end
