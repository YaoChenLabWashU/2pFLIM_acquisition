function FLIM_SaveIniFile(hObject,handles,filename)
% now saves SPC module settings (for multiple modules) to a .MAT file 
% (with .ini extension)
% gy multiboard 201202
global state

SPCdata = state.spc.acq.SPCdata;  % will be multiple cells in multiboard
save(filename,'SPCdata');
return
