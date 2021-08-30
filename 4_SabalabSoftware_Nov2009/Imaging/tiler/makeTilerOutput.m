function makeTilerOutput
	global state
	
	if state.tiler.duration < (state.tiler.startPulse1 + state.tiler.pulseLength1) | ...
			state.tiler.duration < (state.tiler.startPulse2 + state.tiler.pulseLength2)
		disp('makePulseData: pulse continues past end of acquisition');
		disp('	makePulseData failed.  Please adjust parameters');
		setTilerStatusString('ERROR');
	else
		setTilerStatusString('');
	end
	
	nTiles = state.tiler.nTilesX * state.tiler.nTilesY;
	p=primes(nTiles);
	f=find(p>nTiles/2);
	state.tiler.primeStep=p(f(floor((1+end)/2)));
	
	% for X Y mirrors
	
	totalTime = state.tiler.pulseSeparation/1000 * nTiles;
	state.tiler.mirrorPointsPerPulse = state.tiler.pulseSeparation/1000 * state.tiler.mirrorActualOutputRate;
	state.tiler.mirrorTotalPoints = state.tiler.mirrorPointsPerPulse * nTiles;
	state.tiler.pcellPointsPerPulse = state.tiler.pulseSeparation/1000 * state.tiler.pcellActualOutputRate;
	state.tiler.pcellTotalPoints = state.tiler.pcellPointsPerPulse * nTiles;
	
	state.tiler.mirrorTotalInputPoints = state.tiler.pulseSeparation/1000 * state.tiler.mirrorActualInputRate * nTiles;
	state.tiler.mirrorInputPointsPerPulse = round(state.tiler.duration/1000 *state.tiler.mirrorActualInputRate);
	state.tiler.physTotalInputPoints = state.tiler.pulseSeparation/1000 * state.tiler.physActualInputRate * nTiles;
	
	
	state.tiler.mirrorOutput=zeros(state.tiler.mirrorTotalPoints, 2);
	state.tiler.pcellOutput=zeros(state.tiler.pcellPointsPerPulse, 2);
	
	state.tiler.pcellOutput(:,1)=powerToPcellVoltage(state.tiler.offset1, 1);
	state.tiler.pcellOutput(:,1)=powerToPcellVoltage(state.tiler.offset2, 2);
	
	state.tiler.pcellOutput(round(state.tiler.startPulse1/1000 * state.tiler.pcellActualOutputRate + 1) : ...
		round((state.tiler.startPulse1 + state.tiler.pulseLength1)/1000 * state.tiler.pcellActualOutputRate + 1), 1) = ...
		powerToPcellVoltage(state.tiler.amplitude1, 1);

	state.tiler.pcellOutput(round(state.tiler.startPulse2/1000 * state.tiler.pcellActualOutputRate + 1) : ...
		round((state.tiler.startPulse2 + state.tiler.pulseLength2)/1000 * state.tiler.pcellActualOutputRate + 1), 2) = ...
		powerToPcellVoltage(state.tiler.amplitude2, 2);

	if state.tiler.nTilesX==1
		deltaX = 0;
	else
		deltaX = (state.tiler.maxX-state.tiler.minX)/(state.tiler.nTilesX-1);
	end
	
	if state.tiler.nTilesY==1
		deltaY = 0;
	else
		deltaY = (state.tiler.maxY-state.tiler.minY)/(state.tiler.nTilesY-1);
	end

	state.tiler.XYLookup=zeros(2, nTiles);
	state.tiler.counterLookup=zeros(2, nTiles);
	
	for counter=1:nTiles
		primePlace=(counter*state.tiler.primeStep)-nTiles*floor((counter*state.tiler.primeStep)/nTiles);
		yCounter=floor(primePlace/state.tiler.nTilesX)+1;
		xCounter=primePlace-(yCounter-1)*state.tiler.nTilesX+1;
		xVal = state.tiler.minX + (xCounter-1)*deltaX;
		yVal = state.tiler.minY + (yCounter-1)*deltaY;

		state.tiler.counterLookup(:, counter) = [xCounter yCounter]';
		state.tiler.XYLookup(:, counter) = [xVal yVal]';
		state.tiler.mirrorOutput((counter-1)*state.tiler.mirrorPointsPerPulse + 1 : counter*state.tiler.mirrorPointsPerPulse, 1) = xVal;
		state.tiler.mirrorOutput((counter-1)*state.tiler.mirrorPointsPerPulse + 1 : counter*state.tiler.mirrorPointsPerPulse, 2) = yVal;
	end
	
	set(state.tiler.mirrorInputObj, 'SamplesPerTrigger', state.tiler.mirrorTotalInputPoints);
	set(state.tiler.mirrorInputObj, 'SamplesAcquiredFcnCount', state.tiler.mirrorPointsPerPulse);
	
	set(state.tiler.mirrorOutputObj, 'RepeatOutput', 0);
	
	set(state.tiler.pcellOutputObj, 'RepeatOutput', nTiles);
	
	set(state.tiler.physInputObj, 'SamplesPerTrigger', state.tiler.physTotalInputPoints);
	set(state.tiler.physInputObj, 'samplesAcquiredFcnCount', state.tiler.mirrorPointsPerPulse);
	
	state.tiler.tilerCounter=0;
	updateGUIByGlobal('state.tiler.tilerCounter');
	
	nSmooth = round(state.tiler.shutterDelay/1000*state.tiler.pcellActualOutputRate);
	shutterControl = smooth((state.tiler.pcellOutput(:,1)' + state.tiler.pcellOutput(:,2)') > (powerToPcellVoltage(0, 1) + powerToPcellVoltage(0, 2)), nSmooth)>0;
	shutterControl = [shutterControl(round(nSmooth/2):end) repmat(0, 1, round(nSmooth/2)-1)];
	state.tiler.pcellOutput(:, end+1) = shutterControl;
	
