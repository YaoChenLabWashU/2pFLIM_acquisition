function ivAvgResave
%ivLoadTimeSeries(reload, acqNumbers)
	global gh state

	if nargin<1
		reload=0;
	end
	

	try
		cd(state.imageViewer.filePath);
	end
	
	filenames={};
	filepaths={};
	
	done=0;
	fileCounter=0;
	while ~done
		[fname, pname] = uigetfile('*.tif', ['Choose stack #' num2str(fileCounter)]);
		if isnumeric(fname)
			if fileCounter==0
				return
			end
			done=1;
		else
			fileCounter=fileCounter+1;
			fileNames{fileCounter}=fname;
			filePaths{fileCounter}=pname;
			cd(pname);
		end
	end

	for fileCounter=1:length(fileNames)
		filename=[filePaths{fileCounter} fileNames{fileCounter}]
		[path,name,ext] = fileparts(filename);
		initialImage = opentif(filename);		
		if fileCounter==1
			stackHeader = readImageHeaderTif(filename);
			newImage=double(initialImage);
		else
			newImage=newImage+double(initialImage);
		end
	end
	newImage=uint16(newImage/length(fileNames));
	
	for frame=1:size(newImage, 3)
		if frame==1
			imwrite(newImage(:,:,frame), [filePaths{fileCounter} 'avg_' fileNames{fileCounter}],  'WriteMode', 'overwrite', 'Compression', 'none', 'Description', stackHeader);
		else
			imwrite(newImage(:,:,frame), [filePaths{fileCounter} 'avg_' fileNames{fileCounter}],  'WriteMode', 'append', 'Compression', 'none', 'Description', '');
		end
	end