function spc_FillGUIfromGlobals(setNum)
if setNum==spc_mainChannelChoice
    % uses the spc.fits{setNum} and spc.switchess{setNum} to fill the GUI
    doForGlobalGUIpair('spc','spc.GUI_fits','spc.fits',setNum);
    doForGlobalGUIpair('spc','spc.GUI_switchess','spc.switchess',setNum);
end


function doForGlobalGUIpair(topName,globalGUIlist,globVar,setNum)
eval(['global ' topName]);
eval(['fnames=fieldnames(' globalGUIlist ' );']);
for k=1:numel(fnames)
    fname=fnames{k};
    eval(['ctrl=' globalGUIlist '.(fname);']);
    % if it is a multiwindow variable, then choose the n'th handle
    if numel(ctrl)>1
        ctrl=ctrl(setNum); 
    end
    % now display the value
    try
        eval(['value=' globVar '{setNum}.(fname);']);
    catch
        value=NaN;
    end
    style=get(ctrl,'Style');
    if strcmp(style,'checkbox')
        set(ctrl,'Value',value);
    else
        ud=get(ctrl,'UserData');
        if isfield(ud,'Precision')
            precision=ud.Precision;
            if isempty(precision) || precision==0
                precision=3;
            end
        else
            precision=3;
        end
        set(ctrl,'String',num2str(value,precision));
    end
end

