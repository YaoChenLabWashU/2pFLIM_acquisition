function collapseAxes(handle)
% Collapses spalyed axes onto a single axes...

if nargin < 1
    handle=gcf;
elseif ~istype(handle,'figure')
    error('collapseAxes: Must supply a figure handle');
end

%Find axes to collapse to...
ax=findobj(handle,'type','axes');
if isempty(ax) | length(ax)==1
    return
end
mainAx=[];
tags=get(ax,'tag');
if any(strcmp(tags,'Axis1'))
    mainAx=ax(strcmp(tags,'Axis1'));
    ax(strcmp(tags,'Axis1'))=[];
else
    mainAx=ax(1);
    ax(1)=[];
end
     
for axiscounter=1:length(ax)
    wvs=[findobj(handle,'type','line') findobj(handle,'type','image')];
    if isempty(wvs)
        delete(ax(axiscounter));
        continue
    else
        for plotCounter=1:length(wvs)
            set(wvs(plotCounter),'Parent',mainAx);
        end
        delete(ax(axiscounter));
    end
end
rescaleAxis(mainAx);
splayAxisHorizontal(handle);



