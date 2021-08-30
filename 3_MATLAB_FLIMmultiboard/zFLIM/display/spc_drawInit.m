function spc_drawInit
% create the spc windows for lifetime fitting, projection, and lifetime map
% multiFLIM gy 11/16/11 multiboard 20120221

global state spc gui FLIMchannels
evalin('base','global gui spc FLIMchannels');
gui.gy.roisHaveMoved=0;  % initialize this value

% by default, all other FLIM ini files (spcm, window pos, settings) 
%  are located in the same directory as machineSpecific.ini on the path
if ~isfield(state,'spc') || ~isfield(state.spc,'iniFileDirectory')
    try upath=userpath; cd('c:\'); end  % get us out of any Current Folder choice gy 201204
    state.spc.iniFileDirectory = [fileparts(which('machineSpecific.ini')) filesep];
    try (cd(state.spc.iniFileDirectory)); end    
end
% state.spc.FLIMchoices{chan}: bit 1=display; bit 2=acq/save; bit 3=calculate;
if isfield(state,'spc') && isfield(state.spc,'FLIMchoices')
    FLIMchannels=find(bitget(state.spc.FLIMchoices,1)); % get the list of channels to display
else
    FLIMchannels=1:2;
    state.spc.FLIMchoices=[3 3 0 0 0 0];
end
if isempty(FLIMchannels); FLIMchannels=1:2; end

%Read in window positions from a file
try
    load([state.spc.iniFileDirectory 'flim_gui.mat']);
    gui.spc.figure.positions = positions;
end
%
% WINDOW POSITIONING - use the stored value, or a default value: mod gy 201202
%
try 
    fig1_pos = gui.spc.figure.positions.fig1;
catch
    fig1_pos = [884    59   360   300];
end
try
    fig2_pos = gui.spc.figure.positions.fig2;
catch
    fig2_pos = [884   389   359   236];
end

for k=FLIMchannels
    try
        fLM_pos{k}=gui.spc.figure.positions.figLifetimeMaps{k};
        fLM_pos{k}(4);
        fPr_pos{k}=gui.spc.figure.positions.figProjects{k};
        fPr_pos{k}(4);
    catch
        fLM_defpos = {[884   701   360   300] [884   676   360   300] ...
            [884   651   360   300] [884   626   360   300] ...
            [884   601   360   300] [884   576   360   300]};
        fPr_defpos = {[884   301   360   300] [884   276   360   300] ...
            [884   251   360   300] [884   226   360   300] ...
            [884   201   360   300] [884   176   360   300]};
        fLM_pos{k}=fLM_defpos{k};
        fPr_pos{k}=fPr_defpos{k};
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fig1. 'Projection' figures (total intensity) - for multiFLIM, make one for each figure
try % change the default roi to be the full figure
    roi_pos = [1,1,spc.datainfo.scan_x,spc.datainfo.scan_y];
catch
    roi_pos = [1,1,128,128];
end
for fc=FLIMchannels
    spc_initProjectionFigure(fc,fPr_pos{fc},roi_pos)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fig2:  The lifetime curves (single fig for all channels)
gui.spc.figure.lifetime = figure;
set(gui.spc.figure.lifetime, 'Position', fig2_pos, 'name', 'Lifetime');
% main lifetime curve axes
    gui.spc.figure.lifetimeAxes = axes;
    set(gui.spc.figure.lifetimeAxes, 'Position', [0.15, 0.37, 0.8, 0.57], 'XTick', []);
    xlabel(''); ylabel('Photon'); cla; hold on;
% axes for residuals
    gui.spc.figure.residual = axes;
    set(gui.spc.figure.residual, 'position', [0.15, 0.15, 0.8, 0.18]);
    xlabel('Lifetime (ns)'); ylabel('Residuals'); cla; hold on;
% chi-squared title:
    bkc=get(gui.spc.figure.lifetime,'Color');
    uicontrol('Style','text','String','c2:','FontName','Symbol','ForegroundColor','k','BackgroundColor',bkc,'Unit','centimeters','Position',[0,0.1,0.45,.4]);
   
% now the data plots for the lifetimes - updated for multiFLIM gy 20111116
    tRes=64; % default time resolution (might need to fix this??) TODO
    tScale=50/4/tRes;
    xScale=(1:tRes)*tScale;
    cols='kbgmcr'; % colors for the plots
    for fc=FLIMchannels
        % make a plot (and fit) for each channel
        col=cols(fc);
    	axes(gui.spc.figure.lifetimeAxes);
        if ~bitget(state.spc.FLIMchoices(fc),3) % avoid calc'ed channels
            lifeplot=plot(xScale, zeros(tRes,1),'.');
            gui.spc.figure.lifetimePlot(fc) = lifeplot;
            set(lifeplot,'Color',col);
            gui.spc.figure.fitPlot(fc) = plot(xScale, zeros(tRes, 1));
            set(gui.spc.figure.fitPlot(fc),'Color',col); % gy 201112 same color as data
        else
            gui.spc.figure.lifetimePlot(fc)=plot(0,0,['.' col]);
            gui.spc.figure.lifetimePlot(fc)=plot(0,0,['.' col]);
        end
        axes(gui.spc.figure.residual);
        if ~bitget(state.spc.FLIMchoices(fc),3) % avoid calc'ed channels
            gui.spc.figure.residualPlot(fc) = plot(xScale, zeros(tRes, 1));
            set(gui.spc.figure.residualPlot(fc),'Color',col);
        else
            gui.spc.figure.residualPlot(fc)=plot(0,0,['.' col]);
        end
        % set up chi squared display - gy 201112
        if ~bitget(state.spc.FLIMchoices(fc),3) % avoid calc'ed channels
            gui.spc.chisq(fc)=uicontrol('Unit','centimeters','Position',[(fc-1)*1.35+0.5,0.1,1.1,.4],'Style','text','String','','ForegroundColor',col,'BackgroundColor','w','FontSize',8);
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fig3.
for fc=FLIMchannels
    spc_initLifetimeMapFigure(fc,fLM_pos{fc},roi_pos);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spc_main;  % now start the main GUI for FLIM analysis


% TODO fix startup init of values
spc.datainfo.psPerUnit=195.4292;  %in case file read fails

try load([state.spc.iniFileDirectory 'spc_backup.mat']); end  % has the last used fit values

% GY 201012 - spc_backup.mat now stores the fit parameters and the display
%  settings for the lifetimeMap window
%  restore them now if they're available
if exist('spc_fits','var') == 1
    spc.fits = spc_fits;
    for fc=FLIMchannels
        try
            if ~isfield(spc.fits{fc},'tauEmpirical')
                spc.fits{fc}.tauEmpirical=0;
            end
        end
    end
    spc_translateFitsToFit(1);  % TODO - may be able to remove this eventually
else
    % "default values"
    spc.fit.beta0(1:6)=[1000 20 1000 10 5 20];
    spc.fit.fixtau1=1;
    spc.fit.fixtau2=1;
    spc.fit.fix_g=0;
    spc.fit.fix_delta=0;
    spc.fit.range=[10 55];
    spc.fit.tauEmpirical=0;
    spc.fits{1}.range=spc.fit.range;
    for fc=FLIMchannels
        spc_translateFitToFits(fc);
    end
end
if exist('spc_switchess','var')==1
    spc.switchess = spc_switchess;
    spc.switches.logscale=1; % TODO legacy variables
    spc.switches.imagemode=1; % TODO legacy variables
    %spc_translateFitsToFit(1); % TODO - may be able to remove this eventually
    spc_updateGUIbyGlobal('spc.switchess',spc_mainChannelChoice,'figOffset');
else
    % TODO fix startup init of values
    set(gui.spc.spc_main.fixtau1,'Value',1);
    set(gui.spc.spc_main.fixtau2,'Value',1);
    set(gui.spc.spc_main.fix_g,'Value',0);
    set(gui.spc.spc_main.fix_delta,'Value',0);
    for fc=FLIMchannels
        spc_translateFitToFits(fc);
        spc_dispbeta;
    end
end

for fc=FLIMchannels
    spc_FillGUIfromGlobals(fc);
end

% if exist('spc_switches','var') == 1
%     spc.switches = spc_switches;
%     try  % added gy 20110124
%         set(gui.spc.spc_main.F_offset,'String',num2str(spc.switches.figOffset));
%     end
% end

if exist(spc_filename) == 2
    spc.filename=spc_filename;
    spc_updateGUIbyGlobal('spc.filename');
    try spc_openCurves(spc_filename); end
end

% try
try
    [filepath, basename, filenumber, max] = spc_AnalyzeFilename(spc.filename);
    set(gui.spc.spc_main.File_N, 'String', num2str(filenumber));
end
% spc_updateMainStrings;
% catch
%     disp('Error: Strings in spc_main are not updated (function spc_drawInit)');
% end

% GY: need to set these fixed AFTER doing spc_dispbeta (otherwise GUI
% values prevail!)
% set(gui.spc.spc_main.fixtau1,'Value',spc.fit.fixtau1);
% set(gui.spc.spc_main.fixtau2,'Value',spc.fit.fixtau2);
% set(gui.spc.spc_main.fix_g,'Value',spc.fit.fix_g);
% set(gui.spc.spc_main.fix_delta,'Value',spc.fit.fix_delta);


if isfield(gui.spc, 'FLIMgui')
    try
        pos1 = gui.spc.figure.positions.FLIMgui;
    catch
        pos1 = [100, 30, 45.6, 18];
    end
    set(gui.spc.FLIMgui.figure1, 'Position', pos1);
end;

% GY 20110126 position laserControl if it is around
if isfield(gui.spc.figure, 'laser') && isfield(gui.spc.figure.positions,'laser')
    try set(gui.spc.figure.laser,'Position',gui.spc.figure.positions.laser); end;
end


try  % reposition spc_main
    pos1 = gui.spc.figure.positions.spc_main;
catch
    pos1 = [143.4000   45.5385   83.6000   26.1538];
end
set(gui.spc.spc_main.spc_main, 'Position', pos1);

spc_restoreImageROIs;  % if gui.gy still contains ROI positions, redraw them

% if isfield(spc, 'imageMod')
%     try
% 	    % TODO:  redraw everything...
%         spc_redrawSetting;
%     catch
%         disp('Error: no images produced (function spc_drawInit)');
%     end
% end

% might WANT to RESTORE THIS gy 201111
% try %TODO update for multiFLIM
% 	if length(spc.lifetime) > 3
%     if isfield(spc.fit,'lastFitFunction')
%         % use the last fit function automatically
%         fh=str2func(spc.fit.lastFitFunction);
%         fh();
%     else spc_fitexp2gaussGY;
%     end
%     spc_main_fixMenuChecks;
%     %spc_dispbeta;
% 	end
% end
%spc_selectAll;