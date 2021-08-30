function founderr=runLineScanAnalysis
	global state imageData
	
	founderr=0;
	% calculate line scan
	
	state.analysis.deltax = state.acq.msPerLine;
	
    
	analysisData=cell(1, state.init.maximumNumberOfInputChannels+10);
	
	analyzedChannels=zeros(1,state.init.maximumNumberOfInputChannels);
	for channel=1:state.init.maximumNumberOfInputChannels
		if ~isempty(imageData{channel}) && getfield(state.analysis, ['anaChannel' num2str(channel)])
			if ndims(imageData{channel})==3
				tempData=permute(imageData{channel}, [2 1 3]);
				analysisData{channel} = tempData(:,:)';
				if state.acq.dualLaserMode==2	% we are acquiring with alternating	lines
					analysisData{channel+10} = permute(imageData{channel+10}, [2 1 3])';		
				end
			else
				analysisData{channel} = imageData{channel};
				if state.acq.dualLaserMode==2	% we are acquiring with alternating	lines
					analysisData{channel+10} = imageData{channel+10};
				end
            end
            analyzedChannels(channel)=1;
		end
	end
	
	analyzedChannels=find(analyzedChannels);
	if state.acq.dualLaserMode==2
		analyzedChannels=[analyzedChannels analyzedChannels+10];
	end

	state.analysis.analyzedChannels=analyzedChannels;
	state.analysis.avgLineScan=calcLineScan(...
		analysisData{state.analysis.avgLineScanChannel}, ...
		state.analysis.avgLineScanStart, state.analysis.avgLineScanEnd, 1);	% set smoothing to 1

	setWave('avgLineScanWave', 'data', state.analysis.avgLineScan);
	
	% 	determine ROIs
	offset=getfield(state.acq, ['pmtOffsetChannel' num2str(state.analysis.avgLineScanChannel)])*state.acq.binFactor;
	offsetAmp=offset;
	if getfield(state.acq, ['pmtOffsetAutoSubtractChannel' num2str(state.analysis.avgLineScanChannel)])
		offset=0;
	end
	setWave('offsetWave', 'data', repmat(offset, 1, evalin('base', 'length(avgLineScanWave)')));
	
	if state.analysis.autosetROI
		[roix, roiy]=findPeaks(state.analysis.avgLineScan, state.analysis.numberOfROI, offset, state.analysis.roiWidth); 
		%why did I have offset+offsetAmp/5?
			
		state.analysis.roiDefs = roix;
	else
		for counter=1:state.analysis.numberOfROI
			roix = state.analysis.roiDefs(:,1:2);
			roiy = state.analysis.avgLineScan(roix);
		end
	end
	
	if (size(roix, 1) < state.analysis.numberOfROI) || (size(roix, 2) ~= 2)
		founderr=1;
		disp('*** Need to select proper number of 1D ROIs or autoset could not find sufficient ROIs ***');
		setStatusString('INCORRECT 1D ROIs');
		clear analysisData
		return
	end

	for counter=1:state.analysis.numberOfROI
		if counter<=size(roix, 1)
            if ~iswave(['roi_' num2str(counter) 'x'])
    			wave(['roi_' num2str(counter) 'x'], roix(counter, :)-1);
            else
    			setWave(['roi_' num2str(counter) 'x'], 'data', roix(counter, :)-1);
            end
                
            if ~iswave(['roi_' num2str(counter) 'y'])
			    wave(['roi_' num2str(counter) 'y'], roiy(counter, :));
            else
    			setWave(['roi_' num2str(counter) 'y'], 'data', roiy(counter, :));
            end
		else
            if iswave(['roi_' num2str(counter) 'x'])
    			setWave(['roi_' num2str(counter) 'x'], 'data', []);
            end                
            if iswave(['roi_' num2str(counter) 'y'])
    			setWave(['roi_' num2str(counter) 'y'], 'data', []);
            end                
		end			
	end
	
	counter=state.analysis.numberOfROI+1;
	while iswave(['roi_' num2str(counter) 'x'])
		evalin('base', ['roi_' num2str(counter) 'x.data=[];']);
        if iswave(['roi_' num2str(counter) 'y'])
			evalin('base', ['roi_' num2str(counter) 'y.data=[];']);
        end                
		counter=counter+1;
	end

	% 	get fluorescence profile
	state.analysis.roiFluorData=cell(1, state.init.maximumNumberOfInputChannels+10);
	
	numLines=[];
 	for channel=analyzedChannels
		offset=0;
		rawChannel=mod(channel, 10);
		if getfield(state.analysis, ['autosubOffset' num2str(rawChannel)]) ...
				&& ~getfield(state.acq, ['pmtOffsetAutoSubtractChannel' num2str(rawChannel)])
			offset=getfield(state.acq, ['pmtOffsetChannel' num2str(rawChannel)])*state.acq.binFactor;
		end

		state.analysis.roiFluorData{channel} = ...
			roiFluor(analysisData{channel}, state.analysis.roiDefs, offset);
	end
	
	clear analysisData

