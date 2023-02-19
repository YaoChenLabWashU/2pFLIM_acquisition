function out=MaxofMaxProjection()

	global state
	
	if timerGetActiveStatus('Imaging') && ~state.acq.lineScan && state.acq.maxImage1 && (state.cycle.currentCyclePosition==2)
		global  projectionData
		if ~iswave('roiMaxWave')
			waveo('roiMaxWave', []);
		end
		global roiMaxWave

		out=roiMax(projectionData{1}, state.analysis.roiDefs2D(1:state.analysis.numberOfROI, :), ...
			state.acq.pmtOffsetChannel1*state.acq.binFactor);
		roiMaxWave(state.files.lastAcquisition)=out;

	end