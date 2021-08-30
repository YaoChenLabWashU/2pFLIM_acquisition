function movePiezoTo(Z)			% BSMOD2

	global state
	
	if ~state.init.piezoOn
		return
	end
	
	if nargin~=1
		disp('movePiezoTo: Function called with wrong inputs.  Moving to 0 position');
		Z=0;
	end
	
	if Z<0
		disp(['movePiezoTo: Attempt to move piezo to ' num2str(Z) ' microns']);
		disp(['   Piezo can not move to negative excursions. No movement made.']);
		return
	end

	if Z>state.piezo.maxExcursion
		disp(['movePiezoTo: Attempt to move piezo to ' num2str(Z) ' microns']);
		disp(['   Maximum excursion to set up ' num2str(state.piezo.maxExcursion) ...
				'.  No movement made.']);
		return
	end
		
	putsample(state.init.aoPiezo, state.piezo.voltsAtZeroPosition+state.piezo.voltsPerMicron*Z);	

	