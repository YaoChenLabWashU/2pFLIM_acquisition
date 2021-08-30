function spc_redrawSetting (flag, fast)
% recalcs projection, sets proj contextmenu,
global spc gui FLIMchannels state

if nargin==0
    flag = 1;
    fast = 0;
end
if nargin < 2
    fast = 0;
end

if flag % recalc the projections
  for chan=FLIMchannels  % inefficient TODO all 
      if bitget(state.spc.FLIMchoices(chan),3) % needs to be calculated
          spc_calcSpecialChannel(chan);
      else
          spc.projects{chan} = reshape(sum(spc.imageMods{chan}, 1), spc.SPCdata.scan_size_x, spc.SPCdata.scan_size_y); %swapped x and y (gy 201201)
          % null this out to start, for normal channels
          spc.fits{chan}.dependentChan=[];
      end
%       if spc.SPCdata.line_compression > 1
%           aa = 1/spc.SPCdata.line_compression;
%           [yi, xi] = meshgrid(aa:aa:spc.SPCdata.scan_size_x, aa:aa:spc.SPCdata.scan_size_y);
%           spc.project = interp2(spc.projects{chan}, yi, xi)*aa*aa;
%           spc.size(2) = spc.SPCdata.scan_size_x /aa;
%           spc.size(3) = spc.SPCdata.scan_size_y /aa;
%           spc.project(isnan(spc.projects{chan})) = 0;
%       end
  end
end

if 0  % ~fast   gy 201111 - not sure this is ever necessary
    if ~isfield(gui.spc.projects{1},'projectImage')
        for fc=FLIMchannels
            try
                roi_pos = get(gui.spc.projects{chan}.roi, 'Position');
            catch
                roi_pos = [1, 1, spc.size(3)-1, spc.size(2)-1];
            end
            axes(gui.spc.projects{fc}.axes);
            roi_context = uicontextmenu;
            gui.spc.projects{fc}.projectImage = image('CData',spc.projects{fc}, 'CDataMapping', 'scaled', 'UIContextMenu', roi_context);
            item1 = uimenu(roi_context, 'Label', 'make new roi', 'Callback', ['spc_makeRoi(' num2str(fc) ')']);
            item2 = uimenu(roi_context, 'Label', 'select all', 'Callback', ['spc_selectAll(' num2str(fc) ')']);
            %item3 = uimenu(roi_context, 'Label', 'binning 2x2', 'Callback', 'spc_binning');
            %item4 = uimenu(roi_context, 'Label', 'smoothing 2x2', 'Callback', 'spc_smooth(2)');
            %item5 = uimenu(roi_context, 'Label', 'smoothing 3x3', 'Callback', 'spc_smooth(3)');
            %item6 = uimenu(roi_context, 'Label', 'smoothing 4x4', 'Callback', 'spc_smooth(4)');
            %item7 = uimenu(roi_context, 'Label', 'undo', 'Callback', 'spc_undo');
            %item8 = uimenu(roi_context, 'Label', 'restrict in roi', 'Callback', ['spc_selectRoi(' num2str(fc) ')']);
            item9 = uimenu(roi_context, 'Label', 'log-scale', 'Callback', 'spc_logscale');
            cbMakeImageROI=['spc_makeImageROI(' num2str(fc) ',1)']; % for projectN window
            cbDeleteAllROIs=['spc_deleteAllROIs(1:2)']; % all channels affect all
            uimenu(roi_context, 'Label', 'gy: Add ROI', 'Callback', cbMakeImageROI);
            uimenu(roi_context, 'Label', 'gy: Delete all ROIs', 'Callback', cbDeleteAllROIs);
            set(gui.spc.projects{fc}.axes, 'XTick', [], 'YTick', []);
            %draw default roi in Fig1.
            gui.spc.projects{fc}.roi = rectangle ('position', roi_pos, 'ButtonDownFcn', 'spc_dragRoi', 'EdgeColor', [1,1,1]);
        end
    else
        for fc=FLIMchannels  % inefficient TODO all
            set(gui.spc.projects{fc}.projectImage, 'CData', spc.projects{fc});
        end
    end
    %colorbar;
    %spc_plotGYrois(fc,1);
else
    for fc=FLIMchannels  % inefficient TODO all
        axes(gui.spc.projects{fc}.axes);
        set(gui.spc.projects{fc}.projectImage, 'CData', spc.projects{fc});
    end
end


for chan=FLIMchannels
 spc_drawAll(chan, flag, fast); %flag = calculation of lifetimeMap
end
spc_conformROIpositions;
spc_calculateROIvals(0);




% TODO - maybe look at these roi related lines
try
    for i = 1:length(spc.fits{chan}.spc_roi)
        rectstr = ['RoiA', num2str(i)];
        textstr = ['TextA', num2str(i)];
        Rois = findobj('Tag', rectstr);
        Texts = findobj('Tag', textstr);
        for j = 1:length(Rois)
            delete(Rois(j));
        end
        for j = 1:length(Rois)
            delete(Texts(j));
        end

        try
            figure(gui.spc.figure.project);
            %gui.spc.figure.roiA(i) = rectangle('Position', spc.fit.spc_roi{i}, 'Tag', rectstr, 'EdgeColor', 'cyan', 'ButtonDownFcn', 'spc_dragRoiA');
            %gui.spc.figure.textA(i) = text(spc.fit.spc_roi{i}(1), spc.fit.spc_roi{i}(2), num2str(i), 'color', 'red', 'Tag', textstr, 'ButtonDownFcn', 'spc_deleteRoiA');
            for fc=FLIMchannels
                spc_drawLifetime(fc);
            end

            figure(gui.spc.figure.lifetimeMap);
            %gui.spc.figure.roiB(i) = rectangle('Position', spc.fit.spc_roi{i}, 'Tag', rectstr, 'EdgeColor', 'cyan', 'ButtonDownFcn', 'spc_dragRoiA');
            %gui.spc.figure.textB(i) = text(spc.fit.spc_roi{i}(1), spc.fit.spc_roi{i}(2), num2str(i), 'color', 'red', 'Tag', textstr, 'ButtonDownFcn', 'spc_deleteRoiA');
            spc_plotGYrois(fc);
        end
    end
end
