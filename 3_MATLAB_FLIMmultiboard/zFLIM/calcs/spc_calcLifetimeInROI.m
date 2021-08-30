function spc_calcLifetimeInROI(chan,mask)
% for channel 'chan' applies 'mask' and LUTlower to calculate
% lifetime histogram  ---- gy 20120724

global spc

% exclude pixels lower than the LutLower threshold
if spc.SPCdata.line_compression >= 2
    ss = spc.SPCdata.line_compression;
    index = (spc.projects{chan} >= spc.switchess{chan}.LutLower);
    [yi, xi] = meshgrid(ss:ss:spc.SPCdata.scan_size_x*ss, ss:ss:spc.SPCdata.scan_size_y*ss);
    index = interp2(index, yi, xi, 'nearest');
else
    index = (spc.projects{chan} >= spc.switchess{chan}.LutLower);
end

% combine this selector with the mask
% TODO - this does NOT include line compression
index = index .* mask;

% extend and shape this back to the 3D matrix required to select
% from the raw lifetime data in imageMod
siz = size(index);
%bw = (spc.lifetimeMap > 1);
%index =index.*bw;        siz = size(index);
index = repmat (index(:), [1,spc.size(1)]);
index = reshape(index, siz(1), siz(2), spc.size(1));
index = permute(index, [3,1,2]);

imageMod = index .*  spc.imageMods{chan}; % reshape((spc.imageMod), spc.size(1), spc.SPCdata.scan_size_y, spc.SPCdata.scan_size_x);

spc.lifetimes{chan} = reshape(sum(sum(imageMod, 2),3), 1, spc.size(1));
