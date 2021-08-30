function spc_selectAll(chan)
% resets lifetime ROI for this channel to full image
global spc
global gui
spc.size = size(spc.imageMods{chan});
spc_roi = [1, 1, spc.SPCdata.scan_size_x*spc.SPCdata.line_compression, spc.SPCdata.scan_size_y*spc.SPCdata.line_compression];
set(gui.spc.projects{chan}.roi, 'Position', spc_roi);
set(gui.spc.lifetimeMaps{chan}.mapRoi, 'Position', spc_roi);
%spc.roipoly{chan} = ones(spc.SPCdata.scan_size_x*spc.SPCdata.line_compression, spc.SPCdata.scan_size_y*spc.SPCdata.line_compression);
spc_drawLifetime(chan);
%spc_redrawSetting;