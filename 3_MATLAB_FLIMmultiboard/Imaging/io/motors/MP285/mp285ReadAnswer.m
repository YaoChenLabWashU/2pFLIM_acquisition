function [tline,msg]=mp285ReadAnswer
	global state
	if length(state.motor.serialPortHandle) == 0
		disp(['MP285Talk: MP285 not configured']);
		return;
    end
    
    %
    % gy modified code 201204 - uses built-in Timeout of the serial device
    %
    [tline,~,msg] = fgetl(obj); % should return no terminator
    return
    