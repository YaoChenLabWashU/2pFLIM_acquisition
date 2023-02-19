function spc_openFiles(filenum,incr)
% opens spc and image files based on the current base file name
% if filenum is zero, apply the increment to the current filename

global spc gui ROIPosMatrix

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

if exist(spcFile,'file')
%     spcFile
    spc_openCurves (spcFile);
    set(gui.spc.spc_main.File_N,'String',num2str(filenumber));
    if sum(sum(ROIPosMatrix))>0
        [~, name, ext] = fileparts(spc.filename);
        spc.HeaderFile=strcat(name(1:end-7),name(end-2:end),'_hdr.txt'); %Create the name of the HeaderFile that includes cycle position information.
        spc.nROIs=size(gui.gy.roiPositions,2);
        spc.CyclePosition=str2double(GrabCyclePosition(spc.HeaderFile));    %Find Cycle Position from the Header File
        for roi=1:spc.nROIs
            if ROIPosMatrix(spc.CyclePosition, roi)==0
                for type=1:2
                    %                     lines=findall(gui.gy.rois{1,roi}.obj{1,type},'type','line');
                    %                     set(lines,'LineStyle','none');
                    %                     vertices = findobj(gui.gy.rois{1,roi}.obj{1,type},'tag','impoly vertex');
                    %                     set(vertices,'Visible','off');
                    setPosition(gui.gy.rois{1,roi}.obj{1,type}, gui.gy.roiPositions{1,roi}-256*not(spc.shifted(roi))); % move the roi selection out of the way.
                    spc_conformROIpositions;
                end
                
                spc.shifted(roi)=1;
            else
                for type=1:2
                    %                     lines=findall(gui.gy.rois{1,roi}.obj{1,type},'type','line');
                    %                     set(lines,'LineStyle','-')
                    %                     vertices = findobj(gui.gy.rois{1,roi}.obj{1,type},'tag','impoly vertex');
                    %                     set(vertices,'Visible','on');
                    setPosition(gui.gy.rois{1,roi}.obj{1,type}, gui.gy.roiPositions{1,roi}+256*spc.shifted(roi));
                    spc_conformROIpositions;
                end
                spc.shifted(roi)=0;
            end
        end
    end
else
    disp([spcFile, ' does not exist!']);
end

%spc_updateMainStrings;
spc_calculateROIvals(0);