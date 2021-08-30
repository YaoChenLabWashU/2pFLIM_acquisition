function triggerPhys(update)
    if nargin<1
		update=1;
	end
	
	global state physInputDevice
    
    start(physInputDevice);
	trigger(physInputDevice);

	state.internal.triggerTime = clock;


