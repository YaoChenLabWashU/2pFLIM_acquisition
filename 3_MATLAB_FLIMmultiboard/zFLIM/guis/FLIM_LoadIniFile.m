function FLIM_LoadIniFile(filename)
% loads .ini file (actually a .mat file) for multiple SPC modules
% gy multiboard 201202
global state
load(filename,'-mat');
for m=state.spc.acq.modulesAvail
    state.spc.acq.SPCdata{m+1}=SPCdata{m+1};
    FLIM_setParameters(m);
    FLIM_getParameters(m);
end
