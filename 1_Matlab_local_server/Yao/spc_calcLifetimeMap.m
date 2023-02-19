function spc_calcLifetimeMap(chan)
% calculates lifetime map
% TODO gy multiFLIM 20111116
global spc state gui

if bitget(state.spc.FLIMchoices(chan),3)  % special channel
    spc_calcLifetimeMapSpecial(chan);
    return
end

% get the values we need
nsPerPoint=spc.datainfo.psPerUnit/1000;
range = round([spc.fits{chan}.fitstart spc.fits{chan}.fitend]/nsPerPoint);
pos_max2 = spc.switchess{chan}.figOffset; % changed to offset defined by avgTau calculated to infinity.


% get the ROI
try
    spc_roi = get(gui.spc.projects{chan}.roi, 'Position');
catch
    spc_roi = [1,1,spc.size(3), spc.size(2)];
end

% now validate some parameters TODO: make this central
if pos_max2 == 0 || isnan (pos_max2)
    pos_max2 = nsPerPoint; % GY changed from 1.0 (!)
    spc.switchess{chan}.figOffset = pos_max2;
    spc_updateGUIbyGlobal('spc.switchess',chan,'figOffset');
end
if range(2) > length(spc.lifetimes{chan})
    range(1) = 1;
    range(2) = length(spc.lifetimes{chan});
    spc.fits{chan}.fitstart=range(1)*nsPerPoint;
    spc.fits{chan}.fitend=range(1)*nsPerPoint;
    spc_updateGUIbyGlobal('spc.fits',chan,'fitstart');
    spc_updateGUIbyGlobal('spc.fits',chan,'fitend');
end

% why do we need to recalculate the projection map here??
% project = reshape(sum(spc.imageMods{chan}, 1),spc.SPCdata.scan_size_y, spc.SPCdata.scan_size_x);

% get the lifetime for all photons in all pixels
spc.lifetimeAlls{chan} = reshape(sum(sum(spc.imageMods{chan}, 2), 3), spc.size(1), 1);

% find the position of the maximum
[~, pos_max] = max(spc.lifetimeAlls{chan}(range(1):1:range(2)));
pos_max = pos_max+range(1)-1; % and reference it to the full range

% GY: integrate (N(t)*t), ultimately to get mean lifetime
x_project = 1:length(range(1):range(2));  % T (but unscaled), using the first point as t=1 (unscaled)
x_project2 = repmat(x_project, [1,spc.SPCdata.scan_size_x*spc.SPCdata.scan_size_y]);
x_project2 = reshape(x_project2, length(x_project), spc.SPCdata.scan_size_y, spc.SPCdata.scan_size_x);
sumX_project = spc.imageMods{chan}(range(1):range(2),:,:).*x_project2;
sumX_project = sum(sumX_project, 1);

% GY: now calculate Ntotal for each pixel
sum_project = sum(spc.imageMods{chan}(range(1):range(2),:,:), 1);
sum_project = reshape(sum_project, spc.SPCdata.scan_size_y, spc.SPCdata.scan_size_x); 

spc.lifetimeMaps{chan} = zeros(spc.SPCdata.scan_size_y, spc.SPCdata.scan_size_x);

% GY: make a mask to exclude pixels with no photons
bw = (sum_project > 0);

% GY: calculate sum(N(t)*t)/Ntotal, scale according to time, and subtract
% the Figure Offset value from the GUI
spc.lifetimeMaps{chan}(bw) = (sumX_project(bw)./sum_project(bw))*nsPerPoint-pos_max2;

if spc.SPCdata.line_compression > 1
    aa = 1/spc.SPCdata.line_compression;
    [yi, xi] = meshgrid(aa:aa:spc.SPCdata.scan_size_x, aa:aa:spc.SPCdata.scan_size_y);
    spc.lifetimeMaps{chan} = interp2(spc.lifetimeMaps{chan}, yi, xi); 
    spc.lifetimeMaps{chan}(isnan(spc.lifetimeMaps{chan})) = 0;
end

% stop using spc.roipoly 201111 gy
% if isfield(spc, 'roipoly')
% 	spc.lifetimeMaps{chan}(~spc.roipoly{chan}) = spc.switchess{chan}.lifeLimitUpper;
% end
