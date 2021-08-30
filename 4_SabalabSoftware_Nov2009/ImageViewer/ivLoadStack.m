function ivLoadStack(fname, pname)
	global gh state

% 	% something for autosaving
	if nargin<2
		try
			cd(state.imageViewer.filePath);
		end
		pname='';
	end
	
	if nargin<1
		if state.imageViewer.maxOnly
			[fname, pname] = uigetfile({[state.imageViewer.fileBaseName '*max*.tif;']}, 'Choose max projection to load');
		else
			[fname, pname] = uigetfile({[state.imageViewer.fileBaseName '*.tif;']}, 'Choose stack to load');
		end
	end

%pname='N:\Veronica\DATA\NR1_shRNA\Time_lapse\v368i\'
	if ~isnumeric(fname)
		filename = [pname fname];
	else
		return
	end
	fileCounter=state.imageViewer.tsFileCounter;
	
	[path,name,ext] = fileparts(filename);
	state.imageViewer.fileFullName=filename;
	state.imageViewer.fileBaseName=name(1:end-3);
	updateGUIByGlobal('state.imageViewer.fileBaseName');
	
	switch upper(ext)
		case '.TIF'
			state.imageViewer.stackHeader = readImageHeaderTif(filename);
			state.imageViewer.tsStackHeader{fileCounter} = state.imageViewer.stackHeader;
			if isnumeric(state.imageViewer.tsStackHeader{fileCounter})
				disp(['ivLoadStack : ' filename ' not found']);
				beep;
				return
			end
			for counter=1:2:length(state.imageViewer.parametersToLoad)
				try
					eval(['state.imageViewer.' state.imageViewer.parametersToLoad{counter} ' = valueFromHeaderString(' ...
							'state.imageViewer.parametersToLoad{counter+1}, state.imageViewer.stackHeader);']);
				catch
					disp(['state.imageViewer.' state.imageViewer.parametersToLoad{counter} ' = valueFromHeaderString(' ...
							'state.imageViewer.parametersToLoad{counter+1}, state.imageViewer.stackHeader);']);
					eval(['state.imageViewer.' state.imageViewer.parametersToLoad{counter} ' = [];']);
				end
				updateGUIByGlobal(state.imageViewer.parametersToLoad{counter});
			end
			if isempty(state.imageViewer.dualScanMode)
				state.imageViewer.dualScanMode=1;
			end
			updateGUIByGlobal('state.imageViewer.dualScanMode');
			state.imageViewer.channelsOn=[state.imageViewer.channelOn1, ...
					state.imageViewer.channelOn2, ...
					state.imageViewer.channelOn3, ...
					state.imageViewer.channelOn4];
			
			onChannels=find(state.imageViewer.channelsOn);
			state.imageViewer.dataChannels=zeros(1,20);
			state.imageViewer.dataChannels(onChannels)=1;
			
			if state.imageViewer.dualScanMode==2
				onChannels=[onChannels onChannels+10];
				state.imageViewer.channelsOn(11:14)=state.imageViewer.channelsOn;
				state.imageViewer.dataChannels(10+onChannels)=1;
			end
			state.imageViewer.nChannels=length(onChannels);
			for counter=[1:state.imageViewer.maxChannels 11:(10+state.imageViewer.maxChannels)]
				eval(['state.imageViewer.data' num2str(counter) '=state.imageViewer.dataChannels(counter);']);
				updateGUIByGlobal(['state.imageViewer.data' num2str(counter)]);
			end
				
			if state.imageViewer.nChannels>=1
    			initialImage = opentif(filename);
				nSlices=size(initialImage,3)/state.imageViewer.nChannels;
				if isempty(state.imageViewer.nSlices) | (state.imageViewer.nSlices~=nSlices)
					disp('*** Wrong number of slices in tiff file.  Adjusting...');
					state.imageViewer.nSlices=nSlices;
					updateGUIByGlobal('state.imageViewer.nSlices');
				end
				set(gh.imageViewer.displayedSliceSlider, ...
					'Min', 1, ...
					'Max', state.imageViewer.nSlices, ...
					'SliderStep', [1/max(1,state.imageViewer.nSlices-1) 1/max(1,state.imageViewer.nSlices-1)]);
				state.imageViewer.stackData={[], [], [], []};
				for channelCounter=1:state.imageViewer.nChannels
					channel=onChannels(channelCounter);
					set(state.imageViewer.axis(channel), ...
						'XLIm', [0 state.imageViewer.nPixelsX],  ...
						'YLIm', [0 state.imageViewer.nPixelsY]);
					set(state.imageViewer.projAxis(channel), ...
						'XLIm', [0 state.imageViewer.nPixelsX],  ...
						'YLIm', [0 state.imageViewer.nPixelsY]);
					if channel<10
						eval(['state.imageViewer.offsetChannel' num2str(channel) ...
								'= state.imageViewer.binFactor*state.imageViewer.offsetChannel' num2str(channel) ';']);
					else
						eval(['state.imageViewer.offsetChannel' num2str(channel) ...
								'= state.imageViewer.offsetChannel' num2str(channel-10) ';']);
					end
					state.imageViewer.offsets(channel)=getfield(state.imageViewer, ['offsetChannel' num2str(mod(channel,10))]);
				%	offset=getfield(state.imageViewer, ['offsetChannel' num2str(channel)]);
					state.imageViewer.tsCoredFlatProjection{fileCounter, channel}=zeros(state.imageViewer.nPixelsY,  state.imageViewer.nPixelsX);
					state.imageViewer.tsCoredFlatProjectionIndex{fileCounter, channel}=ones(state.imageViewer.nPixelsY,  state.imageViewer.nPixelsX);
					frames=state.imageViewer.nChannels*[0:nSlices-1]+channelCounter;
                    if state.imageViewer.anaChannels(channel)==1 | state.imageViewer.anaMaxChannels(channel)==1 
    					state.imageViewer.tsStackData{fileCounter, channel}=initialImage(:,:,frames); %)-offset; with convert to double
			    		state.imageViewer.tsCoredStackData{fileCounter, channel}=initialImage(:,:,frames); %)-offset; with convert to double
                    end
				end
            end
		otherwise
			disp('File Not Recognized');
			return
	end

	set(state.imageViewer.compositeAxis, ...
		'XLIm', [0 state.imageViewer.nPixelsX],  ...
		'YLIm', [0 state.imageViewer.nPixelsY]);
	set(state.imageViewer.referenceAxis, ...
		'XLIm', [0 state.imageViewer.nPixelsX],  ...
		'YLIm', [0 state.imageViewer.nPixelsY]);
	state.imageViewer.pixelShiftX=0;
	state.imageViewer.pixelShiftY=0;
	updateGUIByGlobal('state.imageViewer.pixelShiftX');
	updateGUIByGlobal('state.imageViewer.pixelShiftY');
	state.imageViewer.trackerImage=[];
	
 	state.imageViewer.filePath = pname;
 	state.imageViewer.fileName = name;
	updateGUIByGlobal('state.imageViewer.filePath');
	updateGUIByGlobal('state.imageViewer.fileName');

	state.imageViewer.displayedSlice=1;
	updateGUIByGlobal('state.imageViewer.displayedSlice');
	if state.imageViewer.autoMedianFilter
		ivMedianFilter;
	end
	
	state.imageViewer.projectionDataAll=cell(3, 20);
	if state.imageViewer.autoProject
		for dim=1:3
			ivMaxProject(dim);
		end			
	end
		
	state.imageViewer.displaySliceData=cell(1, 20);
	
	ivUpdateFigures;
	ivUpdateLUT;
	if state.imageViewer.trackMode>1
		ivCalculateImageShift;
	end
	ivUpdateVisibleWindows;
