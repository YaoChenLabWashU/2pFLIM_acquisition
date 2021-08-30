function executeGrabOneStackCallback(h)

% executeGrabOneCallback(h).m******
% In Main Controls, This function is executed when the Grab One or Abort button is pressed.
% It will on abort requeu the data appropriate for the configuration.
% 
% Written by: Thomas Pologruto and Bernardo Sabatini
% Cold Spring Harbor Labs
% January 26, 2001

	global state gh
			
	if strcmp(get(gh.siGUI_ImagingControls.grabOneButton, 'Visible'), 'off')		% BSMOD2 eliminated variable 'visible'
		return
	end

	if state.piezo.usePiezo
		if length(state.motor.stackStart)~=1
			disp('*** Stack starting position not defined.');
			setStatusString('Need to set start');
			return
		end

		if length(state.motor.stackStop)~=1
			disp('*** Stack ending position not defined.');
			setStatusString('Need to set end');
			return
		end

		if strcmp(get(gh.siGUI_ImagingControls.grabOneButton, 'String'), 'GRAB')		% BSMOD2 eliminated variable 'val'
			state.piezo.next_pos=state.motor.stackStart;
			piezoUpdatePosition;
		end
		executeGrabOneCallback;		
	else

		if length(state.motor.stackStart)~=3
			disp('*** Stack starting position not defined.');
			setStatusString('Need to set start');
			return
		end

		if length(state.motor.stackStop)~=3
			disp('*** Stack ending position not defined.');
			setStatusString('Need to set end');
			return
		end


		if strcmp(get(gh.siGUI_ImagingControls.grabOneButton, 'String'), 'GRAB')		% BSMOD2 eliminated variable 'val'
			mp285SetVelocity(state.motor.velocityFast);
			setMotorPosition(state.motor.stackStart);
			mp285SetVelocity(state.motor.velocitySlow);
			updateRelativeMotorPosition;
			executeGrabOneCallback;
		else
			executeGrabOneCallback;
		end

	end