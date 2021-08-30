function ivExtractOldObjectInfoDir
	disp('*** Select directory for input file');

	[fname, inPath] = uiputfile('path', 'Choose folder with exps...');
	if inPath == 0
		return
	end

	[fname, outPath] = uiputfile('path', 'Choose folder for output files...');
	if outPath == 0
		return
	end
	
	fileList=dir(inPath);
	
	for fileCounter=1:length(fileList)
		if ~fileList(fileCounter).isdir
			if isempty(strfind(fileList(fileCounter).name, 'savedFigureList'))
				[p, f, e]=fileparts(fileList(fileCounter).name);
				ivExtractOldObjectInfo(...
					fullfile(inPath, fileList(fileCounter).name), ...
					fullfile(outPath, [f '_extObject.mat']));
				disp(' ');
			end
		end
	end