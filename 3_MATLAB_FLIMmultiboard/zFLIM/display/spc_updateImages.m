function spc_updateImages(imgFile,hdrFile)
global spc state gui

disp('spc_updateImages NEEDS WORK gy 201111');

[pathstr, name, ext] = fileparts(imgFile);
gui.gy.filename.num=str2double(name((end-2):end));

% open the header file:
	% open file and read in by line ignoring comments
		fid=fopen(hdrFile, 'r');
		if fid==-1
			disp(['gy_SPCreview: Error: Unable to open file ' hdrFile ]);
			return
		else
			[fullName, per, mf]=fopen(fid);
			fclose(fid);
		end
		header = textread(fullName,'%s', 'commentstyle', 'matlab', 'delimiter', '\n');
        for k=1:length(header)
            try evalc(header{k}); catch; end;
        end

%cd(pname);
if ~isfield(gui.spc.figure,'image')
    gui.spc.figure.image=figure();
end
figure(gui.spc.figure.image);
set(gcf,'CloseRequestFcn',{@closeImage});
colormap('jet');
if state.acq.savingChannel2  % two images acquired
    gui.gy.imgG=single(imread(imgFile,1));
    gui.gy.imgR=single(imread(imgFile,2));
    subplot(3,1,1); gui.gy.pltimgG=imagesc(gui.gy.imgG); colorbar;
    subplot(3,1,2); gui.gy.pltimgR=imagesc(gui.gy.imgR); colorbar;
    gui.gy.bkgG=min(median(gui.gy.imgG));
    gui.gy.bkgR=min(median(gui.gy.imgR));
    % lower limit for intensity to include in ratio
    gui.gy.LLg=20;
    gui.gy.LLr=20;
    ratio=(gui.gy.imgG-gui.gy.bkgG)./(gui.gy.imgR-gui.gy.bkgR);
    ratioOK = (gui.gy.imgG>20+gui.gy.bkgG) & (gui.gy.imgR>20+gui.gy.bkgR);
    gui.gy.ratioBks=ratio .* ratioOK;
    subplot(3,1,3); gui.gy.pltimgRatio=imagesc(gui.gy.ratioBks); colorbar;
    context=gui.gy.pltimgRatio;
else
    gui.gy.imgG=single(imread(imgFile,1));
    gui.gy.pltimgG=imagesc(gui.gy.imgG); colorbar;
    gui.gy.bkgG=min(median(gui.gy.imgG));
    gui.gy.bkgR=[];
    gui.gy.imgR=[];
    gui.gy.ratioBks=[];
    gui.gy.pltimgRatio=[];
    gui.gy.pltimgR=[];
    context=gui.gy.pltimgG;
end
roi_context = uicontextmenu;
    uimenu(roi_context, 'Label', 'Add ROI', 'Callback', 'spc_makeImageROI');
	uimenu(roi_context, 'Label', 'Delete all ROIs', 'Callback', 'spc_deleteAllROIs');    
    set(context,'uicontextmenu',roi_context);

%spc_plotGYrois;
% if isfield(gui.gy,'roiPositions') && ~isempty(gui.gy.roiPositions)
%     for k=1:length(gui.gy.roiObject)
%         % delete(gui.gy.roiObject{k}); %(not needed - deleted with replot)
%         gui.gy.roiObject{k}=impoly(gca,gui.gy.roiPositions{k});
%         setColor(gui.gy.roiObject{k},gui.gy.roiColors(k));
%     end
% end

function closeImage(a,b,c)
global gui
% closes AND removes the gui entry for the window
gui.spc.figure=rmfield(gui.spc.figure,'image');
delete(gcf);
