function ivLoadTimeSeries(reload, acqNumbers)
%ivLoadTimeSeries(reload, acqNumbers)
	global gh state

	if nargin<1
		reload=0;
	end
	
	if state.imageViewer.maxOnly
		maxPrefix='max';
	else
		maxPrefix='';
	end
	
	ivDeleteAllHandles([]);
	
	if nargin==2
		filenames=cell(1, length(acqNumbers));
		filepaths=cell(1, length(acqNumbers));
		for counter=1:length(acqNumbers)
			filenum=num2str(acqNumbers(counter));
			if length(filenum)<3
				filenum=['0' filenum];
			end
			if length(filenum)<3
				filenum=['0' filenum];
			end
			filenames{counter}=[state.imageViewer.fileBaseName filenum maxPrefix '.tif'];
			filepaths{counter}=state.imageViewer.filePath;
		end
		state.imageViewer.tsNumberOfFiles=length(acqNumbers);
		state.imageViewer.tsFileNames=filenames;
		state.imageViewer.tsFilePaths=filepaths;
		reload=1;
	end
	
	if ~reload
		try
			cd(state.imageViewer.filePath);
		end
		
		filenames={};
		filepaths={};
		
		done=0;
		fileCounter=0;
		while ~done
			[fname, pname] = uigetfile({[state.imageViewer.fileBaseName '*' maxPrefix '.tif;']}, ['Choose stack #' num2str(fileCounter)]);
			if isnumeric(fname)
				if fileCounter==0
					return
				end
				done=1;
			else
				fileCounter=fileCounter+1;
				filenames{fileCounter}=fname;
				filepaths{fileCounter}=pname;
				cd(pname);
			end
		end
		% things to record for each stack :
		%	the data in the file
		%	all 3 max projections
		%	the x, y, z shifts relative to the initial
		state.imageViewer.tsNumberOfFiles=fileCounter;
		state.imageViewer.tsFileNames=filenames;
		state.imageViewer.tsFilePaths=filepaths;
	end


	state.imageViewer.tsStackData=cell(state.imageViewer.tsNumberOfFiles, 20);
	if reload<2
		state.imageViewer.tsShift=zeros(state.imageViewer.tsNumberOfFiles, 3);
	end
	state.imageViewer.tsStackHeader=cell(1, state.imageViewer.tsNumberOfFiles);
	state.imageViewer.tsTimeStamp=zeros(state.imageViewer.tsNumberOfFiles, 1);
	state.imageViewer.currentDendriteLength=0;
	updateGUIByGlobal('state.imageViewer.currentDendriteLength')
	if reload<2
		state.imageViewer.tsDendriteLength=zeros(state.imageViewer.tsNumberOfFiles, 1);
	end
	
	state.imageViewer.currentObject=1;
	updateGUIByGlobal('state.imageViewer.currentObject');

	trackMode=state.imageViewer.trackMode;
	
	ivSetValidAnaChannels;
	for fileCounter=1:state.imageViewer.tsNumberOfFiles
		state.imageViewer.tsFileCounter=fileCounter;
		updateGUIByGlobal('state.imageViewer.tsFileCounter');
		if fileCounter==1 & trackMode>1
			state.imageViewer.trackMode=1;
			updateGUIByGlobal('state.imageViewer.trackMode');
		end
		ivLoadStack(state.imageViewer.tsFileNames{fileCounter}, state.imageViewer.tsFilePaths{fileCounter});
		state.imageViewer.tsStackHeader{fileCounter}=state.imageViewer.stackHeader;
		state.imageViewer.tsTimeStamp(fileCounter)=state.imageViewer.triggerTime;
		
		if fileCounter==1 & trackMode>1
			disp('*** select tracking region from file 1 ***');
			beep;
			ivSetTrackerReference;
			state.imageViewer.pixelShiftX=0;
			state.imageViewer.pixelShiftY=0;
			state.imageViewer.pixelShiftZ=0;
			state.imageViewer.trackMode=trackMode;
			updateGUIByGlobal('state.imageViewer.trackMode');
		end
		channelList=find(state.imageViewer.channelsOn);
	%	state.imageViewer.tsStackData(fileCounter, channelList)=state.imageViewer.stackData(channelList);
		
		if reload<2		% cludge -- if we set reload to 2 it means that we loading a saved data set and want to 
						% use the time shifts that we reloaded
			state.imageViewer.tsShift(fileCounter, :)=[...
				state.imageViewer.pixelShiftX ...
				state.imageViewer.pixelShiftY ...
				state.imageViewer.pixelShiftZ];
		end
	end

	ivPadSlices;
	ivApplyTimeSeriesShifts;
	if reload<2	
		state.imageViewer.objStructs=[];
	end

	ivFlipTimeSeries(1, 1);
	ivHighlightObject(1);
	setWave('objectTimeStampWave',  'data', state.imageViewer.tsTimeStamp');
	
	
