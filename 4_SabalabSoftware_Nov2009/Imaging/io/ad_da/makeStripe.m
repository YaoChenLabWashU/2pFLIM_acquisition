function makeStripe(aiF, SamplesAcquired)
% makeStripe.m*****
% Action Function
% Called during the focusMode.m script execution.
% Takes data from data acquisition engine and formats it into a proper intensity image.
%
% This function will take the datainput from the DAQ engine and remove the data for the
% lines that are acquired.  It will then bin the matrix along the columns to produce a final 1024 x 1024 image
%
% Written by: Thomas Pologruto & Bernardo Sabatini
% Harvard Medical School
% HHMI
% Cold Spring Harbor Labs
% 2002 - 2009


	global focusInput state
	
	if state.internal.pauseAndRotate
		stopAndRestartFocus;
		return
	end

	if (state.internal.looping==1) && (state.internal.stripeCounter==1)
		state.internal.secondsCounter=floor(state.internal.lastTimeDelay-etime(clock,state.internal.triggerTime));
		updateGUIByGlobal('state.internal.secondsCounter');
	end

	stripeData = getdata(focusInput, state.internal.samplesPerStripe, 'double'); % Gets enoogh data for one stripe from the DAQ engine for all channels present

	siProcessImageStripe(stripeData, 0);
	
	if state.internal.pauseAndRotate
		stopAndRestartFocus;
		return
	end
	
	if state.internal.abortActionFunctions
		abortFocus
		siRedrawImages
		return
	end

	state.internal.stripeCounter = state.internal.stripeCounter + 1; % increments the stripecounter to ensure proper image displays
	if  state.internal.stripeCounter == state.internal.numberOfStripes			
		state.internal.stripeCounter = 0;
		state.internal.frameCounter = state.internal.frameCounter + 1;
		updateGUIByGlobal('state.internal.frameCounter');
	end
	
	if state.internal.abortActionFunctions
		abortFocus
		siRedrawImages
		return
	end

	if state.internal.frameCounter == state.internal.numberOfFocusFrames
		disp('makeStripe: reached number of focus frames')

		%stopAndRestartFocus;
		%return
	end




		