function spc_initProjectionFigure(chan,fPr_pos,roi_pos)
global gui
thisFig = figure;
gui.spc.projects{chan}.figure = thisFig;
set(thisFig, 'MenuBar', 'none');
set(thisFig, 'Position', fPr_pos, 'name', ['Projection' num2str(chan)]);
%menubar if you want ??
%f = uimenu('Label','User');
%uimenu(f, 'Label', 'makeNewRoi', 'Callback', 'spc_makeRoi');
%uimenu(f, 'Label', 'binning', 'Callback', 'spc_binning');
roi_context = uicontextmenu;
gui.spc.projects{chan}.projectImage = image(zeros(128,128), 'CDataMapping', 'scaled', 'UIContextMenu', roi_context);
gui.spc.projects{chan}.axes = gca;
item1 = uimenu(roi_context, 'Label', 'make new roi', 'Callback', ['spc_makeRoi(' num2str(chan) ')']);
item2 = uimenu(roi_context, 'Label', 'select all', 'Callback', ['spc_selectAll(' num2str(chan) ')']);
%	item3 = uimenu(roi_context, 'Label', 'binning 2x2', 'Callback', 'spc_binning');
%    item4 = uimenu(roi_context, 'Label', 'smoothing 2x2', 'Callback', 'spc_smooth(2)');
%    item5 = uimenu(roi_context, 'Label', 'smoothing 3x3', 'Callback', 'spc_smooth(3)');
%    item6 = uimenu(roi_context, 'Label', 'smoothing 4x4', 'Callback', 'spc_smooth(4)');
%    item7 = uimenu(roi_context, 'Label', 'undo', 'Callback', 'spc_undo');
%item8 = uimenu(roi_context, 'Label', 'restrict in roi', 'Callback', ['spc_selectRoi(' num2str(chan) ')']);
item9 = uimenu(roi_context, 'Label', 'log-scale', 'Callback', 'spc_logscale');
cbMakeImageROI=['spc_makeImageROI(' num2str(chan) ',1)']; % for projectN window
cbDeleteAllROIs=['spc_deleteAllROIs(1:2)']; % all channels affect all
uimenu(roi_context, 'Label', 'gy: Add ROI', 'Callback', cbMakeImageROI);
uimenu(roi_context, 'Label', 'gy: Delete all ROIs', 'Callback', cbDeleteAllROIs);

%set axes properties.
%axes('Position', );
gui.spc.projects{chan}.axes=gca;
set(gui.spc.projects{chan}.axes, 'XTick', [], 'YTick', []);
set(gui.spc.projects{chan}.axes, 'Position',[0.1300    0.1100    0.85    0.8150]);
%set(gui.spc.projects{chan}.axes, 'CLim', [1,spc.switches.threshold]);
%draw default roi in Fig1.

gui.spc.projects{chan}.roi = rectangle('position', roi_pos, 'ButtonDownFcn', ['spc_dragRoi(' num2str(chan) ')'], 'EdgeColor', [1,1,1]);
gui.spc.projects{chan}.projectColorbar = colorbar; %('EastOutside');

% GY additions to show mean projection intensity values for ROI's
gui.spc.projects{chan}.ROImean = uicontrol('Style','text','String','r0 =','Unit','normalized','Position',[.05,.02,.2,.05]);
% gui.spc.projects{chan}.ROI1mean = uicontrol('Style','text','String','r1 =','Unit','normalized','Position',[.3,.02,.2,.05]);
bkc=get(thisFig,'Color');  % the background color
gui.spc.projects{chan}.countROI1 = uicontrol('Style','text','String','','ForegroundColor','r','Unit','normalized','BackgroundColor',bkc,'Position',[.01,.85,.1,.05]);
gui.spc.projects{chan}.countROI2 = uicontrol('Style','text','String','','ForegroundColor','m','Unit','normalized','BackgroundColor',bkc,'Position',[.01,.78,.1,.05]);
gui.spc.projects{chan}.countROI3 = uicontrol('Style','text','String','','ForegroundColor','g','Unit','normalized','BackgroundColor',bkc,'Position',[.01,.71,.1,.05]);
gui.spc.projects{chan}.countROI4 = uicontrol('Style','text','String','','ForegroundColor','w','Unit','normalized','BackgroundColor',bkc,'Position',[.01,.64,.1,.05]);
gui.spc.projects{chan}.countROI5 = uicontrol('Style','text','String','','ForegroundColor',[1 0.5 0],'Unit','normalized','BackgroundColor',bkc,'Position',[.01,.57,.1,.05]);
gui.spc.projects{chan}.countROI6 = uicontrol('Style','text','String','','ForegroundColor','y','Unit','normalized','BackgroundColor',bkc,'Position',[.01,.50,.1,.05]);

% try to catch the ROI adjustment events 
set(thisFig,'WindowButtonUpFcn',@checkForROImovement);

function checkForROImovement(src,evnt)
global gui
if isfield(gui.gy,'roisHaveMoved')  && gui.gy.roisHaveMoved==1 && isfield(gui.gy,'rois')
    spc_conformROIpositions;
    spc_calculateROIvals(0);
end