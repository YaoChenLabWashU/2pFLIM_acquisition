function setAcquisitionParameters
global state 

% setAcquisitionParameter.m****
% Function that sets the samplesAcquiredPerLine and inputRate when the user sets the 
% Fillfractiona dn the msPerLine.

% state.acq.inputRate = 1250000;
% updateGUIByGlobal('state.acq.inputRate');
		
switch state.acq.msPerLineGUI % 1 = 1 ms, 2 = 2ms, 3 = 4 ms, 4 = 8 ms
case 1
	state.acq.samplesAcquiredPerLine = 1024;
		
	switch state.acq.fillFractionGUI
	case 1 % fillFraction = 0.71234782608696
		state.acq.fillFraction =0.71234782608696;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.1500;
		updateGUIByGlobal('state.acq.msPerLine');

	case 2 % fillFraction =  0.74472727272727
		state.acq.fillFraction = 0.7447272727272720000;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.10;
		updateGUIByGlobal('state.acq.msPerLine');

	case 3 % fillFraction = 0.78019047619048
		state.acq.fillFraction = 0.7801904761904800000;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.0500;
		updateGUIByGlobal('state.acq.msPerLine');

	case 4 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.8192000000000000000;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.0;
		updateGUIByGlobal('state.acq.msPerLine');

	case 5 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.8192000000000000000;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.fillFractionGUI = 4;
		updateGUIByGlobal('state.acq.fillFractionGUI');
		state.acq.msPerLine = 1.0;
		updateGUIByGlobal('state.acq.msPerLine');

	case 6 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.8192000000000000000;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.fillFractionGUI = 4;
		updateGUIByGlobal('state.acq.fillFractionGUI');
		state.acq.msPerLine = 1.0;
		updateGUIByGlobal('state.acq.msPerLine');

	case 7 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.8192000000000000000;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.fillFractionGUI = 4;
		updateGUIByGlobal('state.acq.fillFractionGUI');
		state.acq.msPerLine = 1.0;
		updateGUIByGlobal('state.acq.msPerLine');

		
	otherwise 
	end
	
case 2
	state.acq.samplesAcquiredPerLine = 2048;
	
	switch state.acq.fillFractionGUI
	case 1 % fillFraction = 0.71234782608696
		state.acq.fillFraction = 0.71234782608696;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 2.30;
		updateGUIByGlobal('state.acq.msPerLine');

	case 2 % fillFraction =  0.74472727272727
		state.acq.fillFraction = 0.74472727272727;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 2.20;
		updateGUIByGlobal('state.acq.msPerLine');

	case 3 % fillFraction = 0.78019047619048
		state.acq.fillFraction = 0.78019047619048;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 2.10;
		updateGUIByGlobal('state.acq.msPerLine');

	case 4 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.81920000000000;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 2.0;
		updateGUIByGlobal('state.acq.msPerLine');

	case 5 % fillFraction = 0.86231578947368
		state.acq.fillFraction = 0.86231578947368;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.90;
		updateGUIByGlobal('state.acq.msPerLine');

	case 6 % fillFraction = 0.91022222222222
		state.acq.fillFraction = 0.91022222222222;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.80;
		updateGUIByGlobal('state.acq.msPerLine');

	case 7  % fillFraction = 0.91022222222222
		state.acq.fillFraction = 0.91022222222222;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.fillFractionGUI = 6;
		updateGUIByGlobal('state.acq.fillFractionGUI');
		state.acq.msPerLine = 1.80;
		updateGUIByGlobal('state.acq.msPerLine');

		
	otherwise 
	end
	
case 3
	setStatusString('');
	state.acq.samplesAcquiredPerLine = 4096;
		
	switch state.acq.fillFractionGUI
	case 1 % fillFraction = 0.71234782608696
		state.acq.fillFraction = 0.71234782608696;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 4.60;
		updateGUIByGlobal('state.acq.msPerLine');
	case 2 % fillFraction =  0.74472727272727
		state.acq.fillFraction = 0.74472727272727;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 4.40;
		updateGUIByGlobal('state.acq.msPerLine');
	case 3 % fillFraction = 0.78019047619048
		state.acq.fillFraction = 0.78019047619048;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 4.20;
		updateGUIByGlobal('state.acq.msPerLine');
	case 4 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.81920000000000;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 4.00;
		updateGUIByGlobal('state.acq.msPerLine');
	case 5 % fillFraction = 0.86231578947368
		state.acq.fillFraction = 0.86231578947368;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 3.80;
		updateGUIByGlobal('state.acq.msPerLine');
	case 6 % fillFraction = 0.91022222222222
		state.acq.fillFraction = 0.91022222222222;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 3.60;
		updateGUIByGlobal('state.acq.msPerLine');
	case 7  % fillFraction = 0.96376470588235
		state.acq.fillFraction = 0.96376470588235;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 3.400;
		updateGUIByGlobal('state.acq.msPerLine');
		
	otherwise 
	end
	
case 4
	setStatusString('');
	state.acq.samplesAcquiredPerLine = 8192;
	
	switch state.acq.fillFractionGUI
	case 1 % fillFraction = 0.71234782608696
		state.acq.fillFraction = 0.71234782608696;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 9.20;
		updateGUIByGlobal('state.acq.msPerLine');
	case 2 % fillFraction =  0.74472727272727
		state.acq.fillFraction = 0.74472727272727;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 8.80;
		updateGUIByGlobal('state.acq.msPerLine');
	case 3 % fillFraction = 0.78019047619048
		state.acq.fillFraction = 0.78019047619048;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 8.40;
		updateGUIByGlobal('state.acq.msPerLine');
	case 4 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.81920000000000;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 8.0;
		updateGUIByGlobal('state.acq.msPerLine');
	case 5 % fillFraction = 0.86231578947368
		state.acq.fillFraction = 0.86231578947368;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 7.60;
		updateGUIByGlobal('state.acq.msPerLine');
	case 6 % fillFraction = 0.91022222222222
		state.acq.fillFraction = 0.91022222222222;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 7.20;
		updateGUIByGlobal('state.acq.msPerLine');
	case 7  % fillFraction = 0.96376470588235
		state.acq.fillFraction = 0.96376470588235;
		updateGUIByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 6.800;
		updateGUIByGlobal('state.acq.msPerLine');
		
	otherwise 
	end
	
	
otherwise
end

state.internal.samplesPerLine=state.acq.msPerLine*state.acq.actualInputRate/1000;
if state.acq.dualLaserMode==1 % if the lasers are on simulataneously then nothing special
	sampleFactor=1;
elseif state.acq.dualLaserMode==2
	sampleFactor=2;	% if they are alternating, then double the number of acqs before trigger the trigger function
end
state.internal.samplesPerStripe = sampleFactor*state.internal.samplesPerLine*state.acq.linesPerFrame/state.internal.numberOfStripes; 		 

state.acq.samplesAcquiredPerLine=state.acq.samplesAcquiredPerLine*state.acq.inputRate/1250000;
updateGUIByGlobal('state.acq.samplesAcquiredPerLine');
state.internal.samplesPerFrame=state.internal.samplesPerLine*state.acq.linesPerFrame;

if state.internal.trimImageEdges
	state.acq.binFactor=state.acq.samplesAcquiredPerLine/state.acq.pixelsPerLine;
	state.acq.pixelTime=state.acq.msPerLine*state.acq.fillFraction/state.acq.pixelsPerLine;
	if state.acq.bidi
		state.internal.startDataColumnInLine = ...
			1+round(...
			state.internal.samplesPerLine*...
			((1-state.acq.fillFraction)/2+...			
			(state.acq.lineDelay/2+state.acq.mirrorLag)/state.acq.msPerLine));
		state.internal.endDataColumnInLine = state.internal.startDataColumnInLine...
			+ state.acq.pixelsPerLine*state.acq.binFactor-1;	
	else
		state.internal.startDataColumnInLine = ...
			1+round((state.acq.lineDelay+state.acq.mirrorLag)/state.acq.msPerLine*state.internal.samplesPerLine);
		state.internal.endDataColumnInLine = state.internal.startDataColumnInLine ....
			+ state.acq.pixelsPerLine*state.acq.binFactor-1;	
	end
else
	state.acq.binFactor=state.internal.samplesPerLine/state.acq.pixelsPerLine;
	state.acq.pixelTime=state.acq.msPerLine/state.acq.pixelsPerLine;

	state.internal.startDataColumnInLine = 1;
	state.internal.endDataColumnInLine = state.internal.samplesPerLine;	
end
% 	[round((state.acq.lineDelay+state.acq.mirrorLag)/state.acq.msPerLine*state.internal.samplesPerLine)
% 		state.internal.startDataColumnInLine + state.acq.pixelsPerLine*state.acq.binFactor-1]

updateGUIByGlobal('state.internal.startDataColumnInLine');
updateGUIByGlobal('state.internal.endDataColumnInLine');
updateGUIByGlobal('state.acq.binFactor');
updateGUIByGlobal('state.acq.pixelTime');




