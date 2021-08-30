function parkMirrors(xy)
	global state
	
	if nargin~=1
		putsample(state.daq.parkMirrorsOutput, [state.acq.scanOffsetX ...
				state.acq.scanOffsetY])
	else
		if length(xy)~=2
			error('parkMirrors: expected [x y] as input');
		else
			putsample(state.daq.parkMirrorsOutput, xy);	% Queues Data to engine for Board 2 (Mirrors)
		end
	end
	
	
