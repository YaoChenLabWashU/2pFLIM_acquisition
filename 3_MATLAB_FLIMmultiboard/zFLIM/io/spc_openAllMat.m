function spc_openAllMat

[fname,pname] = uigetfile('*.mat','Select the mat-file (path)');
files = dir([pname, '*.mat']);
nfiles = size(files);

for i = 1:nfiles(1) 
    fname = files(i).name;
    if exist([pname, fname]) == 2
        spc_openCurves([pname,fname]);
    end
end