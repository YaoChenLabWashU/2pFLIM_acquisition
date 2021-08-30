function setWaveContextMenu(handle)
%Defines Right Click menus for wave objects....
if all(ishandle(handle))
    for hcounter=1:length(handle)
        h=handle(hcounter);
        if istype(h,'axes')
            cmenu = uicontextmenu('Parent',get(h,'Parent'));
            uimenu(cmenu, 'Label', 'Show Waves on Axes', 'Callback', 'showWaves(gca,1:3)');
            set(h,'UIContextMenu', cmenu);
        elseif istype(h,'line') | istype(h,'image')
            cmenu = uicontextmenu('Parent',get(get(h,'Parent'),'Parent'));
            uimenu(cmenu, 'Label', 'Show Waves for Plot/Image', 'Callback', 'showWaves(gco,1:3)');
            set(h,'UIContextMenu', cmenu);
        end
    end
end
