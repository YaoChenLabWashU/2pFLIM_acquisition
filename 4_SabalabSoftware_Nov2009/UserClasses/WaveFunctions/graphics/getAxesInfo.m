function [ax,newAxes,f,allAx,property_argin]=getAxesInfo(property_argin)
% This function parses the varargin for plotting/appending/imaging
% functions to adhere to all the axes logic.
% outputs the ax handle to use and a parameter indicating if a new
% axes was created.  It also passes out a handle to the 
% figure it makes.
%
% Outputs:
% ax is the handles
% newAxes is a flag indicating if a new axis was created.
% f is the handle to a figure if one was created
% allAx is the length of the axes on the current figure.

newAxes=0;
f=[];
allAx=0;

[ax,property_argin]=getValOfParam(property_argin,'axes');
if isempty(ax)  %No axes passed
    if isempty(findobj('Type', 'axes'))       % If not...make defaults.
        error('append : no axis available for setPlotsProps');
    end
    ax=gca;
elseif ischar(ax) & strcmpi(ax,'all')
    ax=findobj('Type', 'axes');
elseif ~all(istype(ax,'axes')) & isnumeric(ax)
    if ax < 0    %Make a new figure...same as plotting byt then append waves in cell array as new waves.
        f=figure('Color', 'w', 'DoubleBuffer', 'on', 'CloseRequestFcn', 'plotWaveDeleteFcn','KeyPressFcn','plotKeyPressFcn',...
            'WindowButtonDownFcn','plotButtonDwnFcn','WindowButtonUpFcn','plotButtonUpFcn');
        newAxes=1;  % Do in for loop for waves....
        allAx=0;
        UserData.autoScale=1;
    elseif ax==0 %Only works if there is a figure in the workspace to append axes too.
        if ~isempty(findobj('type','figure'))
            f=gcf;
        else
            error('append : no figure to append to.');
        end
        newAxes=1;  % Do in for loop for waves....
        allAx=length(findobj(f, 'Type', 'axes'));
        UserData.autoScale=1;
    else			
        ax=findobj(gcf, 'Type', 'axes', 'Tag', ['Axis' num2str(ax)]);
        if ~isempty(ax)
            ax=ax(1);
        else
            error('append : axis is not in graph');
        end
    end
elseif ~all(istype(ax,'axes')) 
    error('append: invalid axes handle.');
end
setWaveContextMenu(ax);