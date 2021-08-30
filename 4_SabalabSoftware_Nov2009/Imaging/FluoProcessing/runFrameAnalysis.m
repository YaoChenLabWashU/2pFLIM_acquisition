function founderr=runFrameAnalysis
	global state imageData
	
	founderr=0;
	% calculate line scan
	
	state.analysis.deltax = state.acq.msPerLine*state.acq.linesPerFrame;
	
	% check rois
	if (size(state.analysis.roiDefs2D, 1) < state.analysis.numberOfROI) || (size(state.analysis.roiDefs2D, 2) ~= 4)
		founderr=1;
		beep;
		disp('*** Need to select proper number of 2D ROIs ***');
		setStatusString('INCORRECT 2D ROIs');
		return
	end
	
	% 	get fluorescence profile
	state.analysis.roiFluorData=cell(1, state.init.maximumNumberOfInputChannels+10);
	state.analysis.roiBaseLines=cell(1, state.init.maximumNumberOfInputChannels+10);
	state.analysis.roiScanMeans=cell(1, state.init.maximumNumberOfInputChannels+10);

	analyzedChannels=zeros(1,state.init.maximumNumberOfInputChannels);
	for channel=1:state.init.maximumNumberOfInputChannels
		if ~isempty(imageData{channel}) && getfield(state.analysis, ['anaChannel' num2str(channel)])
			analyzedChannels(channel)=1;
		end
	end
	
	analyzedChannels=find(analyzedChannels);
	if state.acq.dualLaserMode==2
		analyzedChannels=[analyzedChannels analyzedChannels+10];
	end
	state.analysis.analyzedChannels=analyzedChannels;
	
	numPoints=[];
	for channel=analyzedChannels
		rawChannel=mod(channel, 10);
		
		offset=0;
		if getfield(state.analysis, ['autosubOffset' num2str(rawChannel)]) ...
				&& ~getfield(state.acq, ['pmtOffsetAutoSubtractChannel' num2str(rawChannel)])
			offset=getfield(state.acq, ['pmtOffsetChannel' num2str(rawChannel)])*state.acq.binFactor;
		end
		
		state.analysis.roiFluorData{channel} = ...
			roiFluor(imageData{channel}, state.analysis.roiDefs2D(1:state.analysis.numberOfROI, :), offset);
		if isempty(numPoints)
			numPoints=size(state.analysis.roiFluorData{channel},2);
			baseFrameStart = max(1, floor(state.analysis.flBaseLineStart/state.analysis.deltax));
			if state.analysis.flBaseLineEnd < 1
				baseFrameEnd = numPoints;
			else
				baseFrameEnd = min(numPoints, ceil(state.analysis.flBaseLineEnd/state.analysis.deltax));
			end
		end
		
		state.analysis.roiBaseLines{channel} = mean(...
			state.analysis.roiFluorData{channel}(:, baseFrameStart:baseFrameEnd), ...
			2);
		state.analysis.roiScanMeans{channel} = mean(...
			state.analysis.roiFluorData{channel}, ...
			2);
	end
end

