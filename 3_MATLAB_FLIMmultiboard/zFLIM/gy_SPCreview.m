function gy_SPCreview(varargin)
% for reviewing FLIM and nonFLIM images collected simultaneously

global spc state gui
%spc.fit.range(1) = 	str2num(get(handles.spc_fitstart, 'String'))/spc.datainfo.psPerUnit*1000;
%spc.fit.range(2) =	str2num(get(handles.spc_fitend, 'String'))/spc.datainfo.psPerUnit*1000;
%page = str2num(get(handles.spc_page, 'String'));

spc.lifetime = zeros(1,64);
[fname,pname] = uigetfile('*.sdt;*.mat;*.tif','Select base-image-file');
[pathstr, name, ext] = fileparts(fname);

imgFile=fullfile(pname,[name ext ]);
spcFile=fullfile(pname,[name(1:(end-3)) 'FLIM' name((end-2):end) '.mat' ]);
hdrFile=fullfile(pname,[name '_hdr.txt' ]);
gui.gy.filename.path=pname;
gui.gy.filename.base=name(1:(end-3));
gui.gy.filename.num=str2double(name((end-2):end));

spc_updateImages(imgFile,hdrFile);
drawnow;
if exist(spcFile) == 2
        spc_openCurves(spcFile, 0);
end
%spc_putIntoSPCS;
%spc_updateMainStrings;
spc_calculateROIvals(0);
