function gy_testGlobalGUImismatch(tol)
setNum=spc_mainChannelChoice;
if nargin==0
    tol=0;
end
% uses the spc.fits{setNum} and spc.switchess{setNum} to fill the GUI
doForGlobalGUIpair('spc','spc.GUI_fits','spc.fits',setNum,tol);
doForGlobalGUIpair('spc','spc.GUI_switchess','spc.switchess',setNum,tol);



function doForGlobalGUIpair(topName,globalGUIlist,globVar,setNum,tol)
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
        dval=get(ctrl,'Value');
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
        dval=str2double(get(ctrl,'String'));
    end
    if ~isnan(value) && value~=dval && (tol==0 || (value~=0 && abs((dval-value)/value)>tol))
        disp([fname ':  globVal=' num2str(value) '  ctrlVal=' num2str(dval)]);
    end
end

