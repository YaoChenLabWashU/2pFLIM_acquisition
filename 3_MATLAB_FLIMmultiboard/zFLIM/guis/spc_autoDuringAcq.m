function spc_autoDuringAcq(varargin)
global spc FLIMchannels gui
handles=gui.spc.spc_main; % guihandles(spc_main);
if get(handles.fit_eachtime,'Value')==1
    for chan=FLIMchannels
        if isfield(spc.fits{chan},'lastFitFunction')
            % use the last fit function automatically
            fh=str2func(spc.fits{chan}.lastFitFunction);
            fh(chan);
        else spc_fitexp2gaussGY(chan);
        end
    end
    % the next call should automatically return if no Excel file is open
    spc_SaveFitToExcel
end