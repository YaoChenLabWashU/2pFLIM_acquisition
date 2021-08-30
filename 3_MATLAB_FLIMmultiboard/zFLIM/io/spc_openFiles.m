function spc_openFiles(filenum,incr)
% opens spc and image files based on the current base file name
% if filenum is zero, apply the increment to the current filename

global spc gui

try
    filepath=gui.gy.filename.path;
    basename=gui.gy.filename.base;
    filenumber=gui.gy.filename.num;
catch
    error('Current filename not specified');
end

if filenum
    filenumber=filenum;
else
    filenumber=filenumber+incr;
end

set(gui.spc.spc_main.File_N,'String',num2str(filenumber));

next_filenumber_str = '000';
next_filenumber_str ((end+1-length(num2str(filenumber))):end) = num2str(filenumber);

imgFile = [filepath, basename, next_filenumber_str, '.tif'];
spcFile = [filepath basename 'FLIM' next_filenumber_str '.mat'];
hdrFile = [filepath basename next_filenumber_str '_hdr.txt'];


if isfield(gui.spc.figure,'image')
    % only display these images if they've been requested before
    spc_updateImages(imgFile, hdrFile);
end

if exist(spcFile)
    spc_openCurves (spcFile);
    set(gui.spc.spc_main.File_N,'String',num2str(filenumber));
else
    disp([spcFile, ' does not exist!']);
end

%spc_updateMainStrings;
spc_calculateROIvals(0);