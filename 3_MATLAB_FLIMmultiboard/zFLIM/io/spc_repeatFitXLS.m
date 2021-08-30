function spc_repeatFitXLS(n)
global gui
if nargin<1
    n=0;
end

handles=guihandles(gui.spc.spc_main.spc_main);
if n>0
    for k=1:n
        spc_main('toExcelAndAdvance_Callback',[],[],handles);
    end
else % go until the end of the files with this name
    stillNew=1;
    while stillNew
        filenum=str2double(get(handles.File_N, 'String'));
        spc_main('toExcelAndAdvance_Callback',[],[],handles);
        newfile=str2double(get(handles.File_N, 'String'));
        stillNew=filenum~=newfile;
    end
end

        
