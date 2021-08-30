function spc_saveSPCSetting
% saves spc window positions (FLIM_gui.mat) and fit settings (spc_backup.mat)
global gui FLIMchannels
global spc;
global gh;
global state;

error1 = 0;
try
	gui.spc.figure.positions.fig2 = get(gui.spc.figure.lifetime, 'Position');
    gui.spc.figure.positions.spc_main = get(gui.spc.spc_main.spc_main, 'Position');
%     gui.spc.figure.positions.lifetimerange = get(gui.spc.lifetimerange.twodialog, 'Position');
%     gui.spc.figure.positions.online = get(gui.spc.online, 'Position');
    for k=FLIMchannels
        gui.spc.figure.positions.figLifetimeMaps{k} = get(gui.spc.lifetimeMaps{k}.figure, 'Position');
        gui.spc.figure.positions.figProjects{k} = get(gui.spc.projects{k}.figure, 'Position');
    end
catch err
    disp('error during saving setting ...');
    disp(err.message);
    error1 = 1;
end
try
    gui.spc.figure.positions.laser = get(gui.spc.figure.laser,'Position');
end

try
    	gui.spc.figure.positions.FLIMgui = get(gh.spc.FLIMgui.figure1, 'Position');
end


% fid = fopen([state.spc.iniFileDirectory 'spcm.ini']);
% [fileName,permission, machineormat] = fopen(fid);
% [pathstr,name,ext] = fileparts(fileName);
% 
% fclose(fid);
pathstr=state.spc.iniFileDirectory(1:end-1);    
try % TODO gy fix this
    if ~error1
        positions = gui.spc.figure.positions;
        save([pathstr filesep 'flim_gui.mat'], 'positions');
    end
end

if isfield(spc, 'imageMod') || isfield(spc, 'imageMods')
    % updated gy 201012 to save fit parameters and switches (from lifetimeMap)
    spc_filename = spc.filename;
    spc_fits = spc.fits;
        try
            for k=FLIMchannels
                spc_fits{k} = rmfield(spc_fits{k},{'curve' 'residual'}); end;
        end
    spc_switchess = spc.switchess;
    try save([pathstr filesep 'spc_backup.mat'], 'spc_filename', 'spc_fits', 'spc_switchess'); end
end