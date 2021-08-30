function spc_setupSliceChooser
global spc gui
ctrl=gui.spc.spc_main.sliceChooser;
slider=gui.spc.spc_main.slider1;
nCurrent=numel(get(ctrl,'String'));
if nCurrent~=spc.datainfo.numberOfZSlices+1
    % set up new string parameter
    str{1}='Sum of all';
    for k=1:spc.datainfo.numberOfZSlices
        str{k+1}=num2str(k);
    end
    set(ctrl,'String',str);
end
% set control to default (either slice 1, or Sum of all)

if spc.datainfo.numberOfZSlices==1
    set(ctrl,'Value',2);
    set(ctrl,'Enable','off');
    set(slider,'Value',0);
    set(slider,'Enable','off');
else
    set(ctrl,'Value',1);
    set(ctrl,'Enable','on');
    set(slider,'Value',0);
    set(slider,'Enable','on');
end

        