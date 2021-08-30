function spc_initLifetimeMapFigure(chan, figpos, roi_pos)
% allows us to draw multiple lifetimeMap figures
% multiFLIM gy 2011116
global spc gui FLIMchannels

thisFig=figure;
gui.spc.lifetimeMaps{chan}.figure = thisFig;
set(thisFig, 'MenuBar', 'none');
set(thisFig, 'Position', figpos, 'name', ['LifetimeMap' num2str(chan)]);
thisFigAxes = axes('Position', [0.1300    0.1100    0.6626    0.8150]);
gui.spc.lifetimeMaps{chan}.axes=thisFigAxes;
lifetimeMap_context = uicontextmenu;
gui.spc.lifetimeMaps{chan}.image = image(zeros(128,128,3), 'CDataMapping', 'scaled', 'UIContextMenu', lifetimeMap_context);
cbMakeImageROI=['spc_makeImageROI(' num2str(chan) ',1)']; % for projectN window
cbDeleteAllROIs=['spc_deleteAllROIs(1:2)']; % all channels affect all
uimenu(lifetimeMap_context, 'Label', 'gy: Add ROI', 'Callback', cbMakeImageROI);
uimenu(lifetimeMap_context, 'Label', 'gy: Delete all ROIs', 'Callback', cbDeleteAllROIs);
%item2 = uimenu(lifetimeMap_context, 'Label', 'Restrict in roi', 'Callback', ['spc_selectRoi(' num2str(chan) ')']);
set(thisFigAxes, 'XTick', [], 'YTick', []);
gui.spc.lifetimeMaps{chan}.mapRoi=rectangle('position', roi_pos, 'EdgeColor', [1,1,1]);
gui.spc.lifetimeMaps{chan}.colorbar = axes('Position', [0.82, 0.11, 0.05, 0.8150]);
scale = 56:-1:9;
image(scale(:));
colormap(jet);
set(gui.spc.lifetimeMaps{chan}.colorbar, 'XTickLabel', []);
set(gui.spc.lifetimeMaps{chan}.colorbar, 'YAxisLocation', 'right', 'YTickLabel', []);
% TODO in next line, try adding '; drawLifetimeMap(' num2str(chan) ',1,0);'
callback=['spc_GUIchange(gcbo,' num2str(chan) ',guidata(gcbo))' '; spc_drawLifetimeMap(' num2str(chan) ',1,0);'];
gui.spc.lifetimeMaps{chan}.lifeLimitUpper = uicontrol('Style', 'edit', 'String', '1', ...
    'Unit', 'normalized', 'Position', [0.88, 0.9, 0.1, 0.05], 'Callback', callback);
gui.spc.lifetimeMaps{chan}.lifeLimitLower = uicontrol('Style', 'edit', 'String', '0', ...
    'Unit', 'normalized', 'Position', [0.88, 0.1, 0.1, 0.05], 'Callback', callback);
gui.spc.lifetimeMaps{chan}.LUTtext = uicontrol('Style', 'text', 'String', 'LUT', ...
    'Unit', 'normalized', 'Position', [0.88, 0.6, 0.1, 0.05], 'BackgroundColor', [0.8,0.8,0.8]);
gui.spc.lifetimeMaps{chan}.LutUpper = uicontrol('Style', 'edit', 'String', '0', ...
    'Unit', 'normalized', 'Position', [0.88, 0.55, 0.1, 0.05], 'Callback', callback);
gui.spc.lifetimeMaps{chan}.LutLower = uicontrol('Style', 'edit', 'String', '0', ...
    'Unit', 'normalized', 'Position', [0.88, 0.5, 0.1, 0.05], 'Callback', callback);
gui.spc.lifetimeMaps{chan}.drawPopulation = uicontrol ('Style', 'checkbox', 'Unit', 'normalized', ...
    'Position', [0.05, 0.02, 0.3, 0.05], 'String', 'Draw population', 'Callback', ...
    callback, 'BackgroundColor', [0.8,0.8,0.8]);

% create the controls to display the ROI lifetimes
bkc=get(thisFig,'Color');  % the background color
gui.spc.lifetimeMaps{chan}.lifeROI1 = uicontrol('Style','text','String','','ForegroundColor','r','Unit','normalized','BackgroundColor',bkc,'Position',[.01,.85,.1,.05]);
gui.spc.lifetimeMaps{chan}.lifeROI2 = uicontrol('Style','text','String','','ForegroundColor','m','Unit','normalized','BackgroundColor',bkc,'Position',[.01,.78,.1,.05]);
gui.spc.lifetimeMaps{chan}.lifeROI3 = uicontrol('Style','text','String','','ForegroundColor','g','Unit','normalized','BackgroundColor',bkc,'Position',[.01,.71,.1,.05]);
gui.spc.lifetimeMaps{chan}.lifeROI4 = uicontrol('Style','text','String','','ForegroundColor','w','Unit','normalized','BackgroundColor',bkc,'Position',[.01,.64,.1,.05]);
gui.spc.lifetimeMaps{chan}.lifeROI5 = uicontrol('Style','text','String','','ForegroundColor',[1 0.5 0],'Unit','normalized','BackgroundColor',bkc,'Position',[.01,.57,.1,.05]);
gui.spc.lifetimeMaps{chan}.lifeROI6 = uicontrol('Style','text','String','','ForegroundColor','y','Unit','normalized','BackgroundColor',bkc,'Position',[.01,.50,.1,.05]);

% now establish the global-GUI pairing for this particular window
% multiple windows means different handle for each member of the global
nCh=max(FLIMchannels);
defs={
    {'lifeLimitUpper','spc.switchess',nCh,'lifeLimitUpper',chan}
    {'lifeLimitLower','spc.switchess',nCh,'lifeLimitLower',chan}
    {'LutUpper','spc.switchess',nCh,'LutUpper',chan}
    {'LutLower','spc.switchess',nCh,'LutLower',chan}
    {'drawPopulation','spc.switchess',nCh,'drawPopulation',chan}
    };
spc_setGlobalGUIPairs(gui.spc.lifetimeMaps{chan},defs);

% try to catch the ROI adjustment events 
set(thisFig,'WindowButtonUpFcn',@checkForROImovement);

function checkForROImovement(src,evnt)
global gui
if isfield(gui.gy,'roisHaveMoved')  && gui.gy.roisHaveMoved==1 && isfield(gui.gy,'rois')
    spc_conformROIpositions;
    spc_calculateROIvals(0);
end