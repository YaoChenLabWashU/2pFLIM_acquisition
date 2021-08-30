function spc_closereq
% closes auxiliary windows when spc_main is closed
%global spcs
global spc
global gui FLIMchannels
% added GY:
spc_saveSPCSetting;
try
    close(gui.spc.figure.lifetime);
    for k=FLIMchannels
        close(gui.spc.lifetimeMaps{k}.figure);
        close(gui.spc.projects{k}.figure);
    end
end
%spcs = [];
spc = [];
%close(gui.spc.spc_main.spc_main);

closereq;
