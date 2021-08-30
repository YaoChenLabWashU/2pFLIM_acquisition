function out=mp285Config
% mp285Config configures the serial port for the mp285 Sutter controler
% 
% mp285Config sets up the serial port (given by sPort, i.e. 'COM2') for communication with 
% Sutter's mp285 stepper motor controller. 
% 
% Class Support
%   -------------
%   The input char variable is the specification of the serial port, 'COM1' or 'COM2'
%	The defulat if 'COM2'. The output is the object handle for the serial port
%		
%   Karel Svoboda 10/1/00 Matlab 6.0R
%	 svoboda@cshl.org
%	Modified 2/5/1 by Bernardo Sabatini to support global state variable

	global state
	state.motor.lastPositionRead=[0 0 0];
	
	if state.motor.resolutionBit==0
		state.motor.resolution=10;
	else
		state.motor.resolution=40;
	end
	
	if state.motor.motorOn==0
		return
	end


% close all open serial port objects on the same port and remove
% the relevant object form the workspace
	port=instrfind('Port',state.motor.port);
	if length(port) > 0; 
		fclose(port); 
		delete(port);
		clear port;
	end

% make serial object named 'mp285'
	state.motor.serialPortHandle = serial(state.motor.port);
	set(state.motor.serialPortHandle, 'BaudRate', state.motor.baud, 'Parity', 'none' , 'Terminator', {'CR','CR'}, ...
		'StopBits', 1, 'Timeout', state.motor.timeout, 'Name', 'mp285');

% open and check status 
	fopen(state.motor.serialPortHandle);
	stat=get(state.motor.serialPortHandle, 'Status');
	if ~strcmp(stat, 'open')
		disp([' mp285Config: trouble opening port; cannot to proceed']);
		state.motor.serialPortHandle=[];
		out=1;
		return;
	end

mp285Talk(state.motor.AbsORRel);
mp285Talk('n'); % updateScreen
mp285SetVelocity(state.motor.velocitySlow,0);

out=0;

