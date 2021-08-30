function runFluorAnalysis(acqNumber)
	global state
	if nargin<1
		acqNumber=[];
	end
	
	if state.analysis.analysisMode==1
		% analysis is off
		return
	elseif (state.analysis.analysisMode==2) || ((state.analysis.analysisMode==4) && state.acq.lineScan)
		% linescan analysis or automatic
		lineScanAnalysis=1;	% line scan
		if state.acq.lineScan 
			founderr=runLineScanAnalysis;
		else
			disp('*** runFluorAnalysis : data is 2d.  Skipping line scan analysis');
			return
		end
	elseif (state.analysis.analysisMode==3) || ((state.analysis.analysisMode==4) && ~state.acq.lineScan)
		lineScanAnalysis=0; % frame scan
		if ~state.acq.lineScan 
			founderr=runFrameAnalysis;
		else
			disp('*** runFluorAnalysis : data is 1d.  Skipping frame analysis');
			return
		end	
	end
		
	if founderr
		return
	end
	
	% calculate baselines and means
	state.analysis.roiBaseline=cell(1, state.init.maximumNumberOfInputChannels+10);
	state.analysis.roiMean=cell(1, state.init.maximumNumberOfInputChannels+10);
	state.analysis.roiPeak=cell(1, state.init.maximumNumberOfInputChannels+10);

	baseLineStartPoint = round(1 + state.analysis.flBaseLineStart/state.analysis.deltax);
	baseLineEndPoint = round(1 + state.analysis.flBaseLineEnd/state.analysis.deltax);
	
	for channel=state.analysis.analyzedChannels
		if lineScanAnalysis
			nROI=min(size(state.analysis.roiDefs, 1), state.analysis.numberOfROI);
		else
			nROI=min(size(state.analysis.roiDefs2D, 1), state.analysis.numberOfROI);
		end
		
		for roiCounter=1:nROI
			if state.analysis.flBaseLineEnd < 1
				baseLineEndPoint = size(state.analysis.roiFluorData{channel},2);
			end
			
			state.analysis.roiBaseline{channel} = mean(...
				state.analysis.roiFluorData{channel}(:, baseLineStartPoint:baseLineEndPoint), ...
				2);
			state.analysis.roiMean{channel} = mean(...
				state.analysis.roiFluorData{channel}, ...
				2);
			
			% store baselines, means in waves
			if ~isempty(acqNumber)
				for roiCounter=1:length(state.analysis.roiBaseline{channel})
					if ~iswave([ROIScanName(channel, roiCounter) '_f0'])
						wave([ROIScanName(channel, roiCounter) '_f0'], 0, 'xscale', [1 1]);
					end
					eval(['global ' ROIScanName(channel, roiCounter) '_f0']);
					eval([ROIScanName(channel, roiCounter) '_f0(acqNumber)=state.analysis.roiBaseline{channel}(roiCounter);']);
					
					if ~iswave([ROIScanName(channel, roiCounter) '_favg'])
						wave([ROIScanName(channel, roiCounter) '_favg'], 0, 'xscale', [1 1]);
					end
					eval(['global ' ROIScanName(channel, roiCounter) '_favg']);
					eval([ROIScanName(channel, roiCounter) '_favg(acqNumber)=state.analysis.roiMean{channel}(roiCounter);']);
				end
			end
		end
	end		
	
	% 	do ratioing
	for channel=state.analysis.analyzedChannels
		ratioMode=getfield(state.analysis, ['ratioMode' num2str(channel)]);
		ratioChannel=mod(ratioMode, 4);
		if ratioChannel==0
			ratioChannel=4;
		end
		if (ratioMode~=13) && ~getfield(state.analysis, ['anaChannel' num2str(ratioChannel)])
			disp(['ERROR: Inactive channel (#' num2str(ratioChannel) ') is selected for ratioing']);
			disp(['       Data was not ratioed']);
		else
			if ratioMode<=4
				% normalize to baseline data
				state.analysis.roiFluorData{channel} = state.analysis.roiFluorData{channel}./...
					repmat(state.analysis.roiBaseline{ratioChannel}, 1, size(state.analysis.roiFluorData{channel},2));
			elseif ratioMode<=8
				% normalize to channel point by point
				state.analysis.roiFluorData{channel} = state.analysis.roiFluorData{counter}./...
					state.analysis.roiFluorData{ratioChannel};
				
			elseif ratioMode<=12
				% normalize to the channel mean
				state.analysis.roiFluorData{channel} = state.analysis.roiFluorData{channel}./...
					repmat(state.analysis.roiMean{ratioChannel}, 1, size(state.analysis.roiFluorData{channel},2));
			end
		end
	end

	% recalculate baselines post ratioing
	state.analysis.roiBaselineR=cell(1, state.init.maximumNumberOfInputChannels);
	for channel=state.analysis.analyzedChannels
		for roiCounter=nROI
			if getfield(state.analysis, ['ratioMode' num2str(channel)])<=9
				state.analysis.roiBaselineR{channel} = mean(...
					state.analysis.roiFluorData{channel}(:, baseLineStartPoint:baseLineEndPoint), ...
					2);
			else
				state.analysis.roiBaselineR{channel} = state.analysis.roiBaseline{channel};
			end
			
			% store baselines, means, and peaks in waves
			if ~isempty(acqNumber)
				for roiCounter=1:length(state.analysis.roiBaseline{channel})
					if ~iswave([ROIScanName(channel, roiCounter) '_rf0'])
						wave([ROIScanName(channel, roiCounter) '_rf0'], 0, 'xscale', [1 1]);
					end
					eval(['global ' ROIScanName(channel, roiCounter) '_rf0']);
					eval([ROIScanName(channel, roiCounter) '_rf0(acqNumber)=state.analysis.roiBaselineR{channel}(roiCounter);']);
				end
			end
		end
	end
	
	% produce waves with results
	for channel=state.analysis.analyzedChannels
		for roiCounter=1:nROI
			if iswave(ROIScanName(channel, roiCounter))
				setWave(ROIScanName(channel, roiCounter), ...
					'data', state.analysis.roiFluorData{channel}(roiCounter, :), ...
					'xscale', [0 state.analysis.deltax]);
			else
				wave(ROIScanName(channel, roiCounter), state.analysis.roiFluorData{channel}(roiCounter, :), ...
					'xscale', [0 state.analysis.deltax]);
			end
			%	setWaveUserDataField(ROIScanName(channel, roiCounter), 'headerString', state.headerString);
			if lineScanAnalysis
				setWaveUserDataField(ROIScanName(channel, roiCounter), 'ROIDef', state.analysis.roiDefs(roiCounter,:));
			else
				setWaveUserDataField(ROIScanName(channel, roiCounter), 'ROIDef', state.analysis.roiDefs2D(roiCounter,:));
			end
			
			if ~isempty(acqNumber)
				duplicateo(ROIScanName(channel, roiCounter), ROIScanName(channel, roiCounter, acqNumber));
			end
		end
	end

	avginROIScans(acqNumber);
	if state.files.autoSave
		saveROIScans(acqNumber);
	end
	
	try
		if state.analysis.active
			runTraceAnalyzer(0);
		end
	catch
		disp(['runFluorAnalysis : ' lasterr]);
		disp('	when doing trace analysis');
	end
	
	if ~state.analysis.keepInMemory
	 	for channel=[1:state.init.maximumNumberOfInputChannels 1:state.init.maximumNumberOfInputChannels+10]
			for roiCounter=nROI
				kill(ROIScanName(channel, roiCounter, acqNumber));
			end
		end
	end
	
% 	