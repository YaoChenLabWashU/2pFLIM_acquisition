function startScope
	global state
	
	if ~strcmp([state.phys.daq.scopeInputDevice.Running state.phys.daq.scopeOutputDevice.Running], ['Off' 'Off'])
		setPhysStatusString('Overrun.  Waiting');
        while ~strcmp([state.phys.daq.scopeInputDevice.Running state.phys.daq.scopeOutputDevice.Running], ...
            ['Off' 'Off']);
        end		
		setPhysStatusString('');
		pause(0.01);
	end

	putScopeData;
	start([state.phys.daq.scopeOutputDevice state.phys.daq.scopeInputDevice]);
   	state.phys.daq.scopeTriggerTime=clock;
	trigger(state.phys.daq.scopeInputDevice);