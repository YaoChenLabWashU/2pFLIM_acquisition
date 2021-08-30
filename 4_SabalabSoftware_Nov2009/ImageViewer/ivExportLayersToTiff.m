function ivExportLayersToTiff(fname, pname)
	global gh state

	if nargin<1
		[fname, pname] = uigetfile({[state.imageViewer.fileBaseName '*.tif;']}, 'Choose stack to load');
	end

	if ~isnumeric(fname)
		filename = [pname fname];
	else
		return
	end

	[path,name,ext] = fileparts(filename);

	[fnameOut, pnameOut] = uiputfile('outputFolder.tif', 'Select output folder');
	if isnumeric(fnameOut)
		return
	end


	stackHeader = readImageHeaderTif(filename);
	if isnumeric(stackHeader)
		disp([' ivExportLayersToTiff : ' filename ' not found']);
		beep;
		return
	end

	dualScanMode = valueFromHeaderString('state.acq.dualLaserMode', state.imageViewer.stackHeader);
	channelOn1 = valueFromHeaderString('state.acq.savingChannel1', state.imageViewer.stackHeader);
	channelOn2 = valueFromHeaderString('state.acq.savingChannel2', state.imageViewer.stackHeader);
	channelOn3 = valueFromHeaderString('state.acq.savingChannel3', state.imageViewer.stackHeader);
	nSlices = valueFromHeaderString('state.acq.numberOfZSlices', state.imageViewer.stackHeader);

	if isempty(dualScanMode)
		dualScanMode=1;
	end
	channelsOn=[channelOn1, ...
			channelOn2, ...
			channelOn3]
	
	onChannels=find(channelsOn);
	
	if dualScanMode==2
		onChannels=[onChannels onChannels+10];
	end
	nChannels=length(onChannels);
		
	if nChannels>=1
		initialImage = opentif(filename);
		nSlicesData=size(initialImage,3)/state.imageViewer.nChannels;
		if isempty(nSlices) | (nSlicesData~=nSlices)
			disp('*** Wrong number of slices in tiff file.  Adjusting...');
			nSlices=nSlicesData;
		end
		for channelCounter=1:nChannels
			channel=onChannels(channelCounter);
			slice=0;
			for frameCounter=nChannels*[0:nSlices-1]+channelCounter
				slice=slice+1;
				disp([name '_c' num2str(channel) '_s' num2str(slice) '.tif'])
				outFileName=fullfile(pnameOut, [name '_c' num2str(channel) '_s' num2str(slice) '.tif']);
				imwrite(initialImage(:,:,frameCounter), ...
					outFileName,  'WriteMode', 'overwrite', 'Compression', 'none', 'Description', stackHeader);
			end
		end
    end
