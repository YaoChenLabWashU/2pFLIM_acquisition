function applyChangesToOutput(force)
	global state
	
	if state.analysisMode
		return
	end

	if nargin == 1
		if force
			state.internal.needNewMirrorOutput = 1;
			state.internal.needNewPcellBinaryOutput = 1;
		end
	end
	
	% The user has changed a basic scan paramater such as scan amplitude,
	% offset, number of lines, duration of line
	% Apply to focus and grab
	if state.internal.needNewMirrorOutput
		% make new sawtook
		if state.acq.bidi
			makeNewSawToothMirrorOutputBi;
		else
			makeNewSawToothMirrorOutput;
		end
			
		state.internal.needNewMirrorOutput=0;
		state.internal.needNewRotatedMirrorOutput=1;
		state.internal.needNewPcellBinaryOutput=1;
	end
	
	% The user has changed a basic scan paramater such a number of lines
	% duration of line or the flyback
	% Apply to focus and grab
	if state.internal.needNewPcellBinaryOutput
		makeNewPcellBinaryOutput;
	
		state.internal.needNewPcellBinaryOutput=0;
		state.internal.needNewPcellPowerOutput=1;
	end

	% Need to rotate, zoom, or translate the mirror positions
	% Apply to focus and grab
	if state.internal.needNewRotatedMirrorOutput
		makeNewRotatedMirrorOutput;
		state.internal.needNewRotatedMirrorOutput=0;
		state.internal.needNewRepeatedMirrorOutput=1;
	end
	
	% user changed the pcell power settings
	if state.internal.needNewPcellPowerOutput
		makeNewPcellPowerOutput;
		
		state.internal.needNewPcellPowerOutput=0;
		state.internal.needNewPcellRepeatedOutput=1;
	end

	if state.internal.status==0 || state.internal.status==4 % nothing or waiting then change grab parameters
		% Need to change number of repeats.  The user changed the number of
		% frames.
		% Need to change blaster positions
		if state.internal.needNewRepeatedMirrorOutput
			makeNewRepeatedMirrorOutput;
			state.internal.needNewRepeatedMirrorOutput=0;
		end		
		
		% user changed the number of frames, the blaster powers, the pcell box
		% powers
		if state.internal.needNewPcellRepeatedOutput
			makeNewPcellRepeatedOutput;
			state.internal.needNewPcellRepeatedOutput=0;
		end
		

		flushFocusData;
		flushGrabData;
        setPcellsToDefault;
		
	elseif state.internal.status==2 % if focusing, leave flags set for future change.  Let makeStripe catch the need to change
		state.internal.pauseAndRotate=1;
	elseif state.internal.status==3 % grabbing -- recognize that they hit the button, but do nothing until next acquisition
		if state.internal.needNewRepeatedMirrorOutput || state.internal.needNewPcellRepeatedOutput
			disp('applyChangesToOutput : Changes will be applied after grab is complete');
		end
	end		

	
	