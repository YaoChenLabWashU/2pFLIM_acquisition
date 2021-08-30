
function out=mp285StartMove(xyz, resolution)
% mp285SetPos controls the position of the mp285
% 
% mp285SetPos 
% 
% Class Support
%   -------------
%   The input variable [x y z] contains the absolute motor target positions in microns. 
%   The optional paramter 'resolution' contains the resolution in nm (nanometers)
%	The value used depends on the mp285 microcode 
%		
%   Karel Svoboda 8/28/00 Matlab 6.0R
%	svoboda@cshl.org
% 	Modified 2/5/1 by Bernardo Sabatini to support global state and preset serialPortHandle

global state
if state.motor.motorOn==0
	return
end

if state.motor.movePending
	disp('mp285StartMove: Error: Move already pending');
	setStatusString('Move pending');
	out=1;
	return
end

if nargin < 1
     disp(['-------------------------------']);  
     disp([' mp285SetPos v',version])
     disp(['-------------------------------']);
     disp([' usage: Mmp285SetPos([x y z])']);
     error(['### incomplete parameters; cannot proceed']); 
end 

if nargin < 2
     resolution=100; % 100nm resolution default
end

if length(xyz) ~=3
     disp(['-------------------------------']);  
     disp([' mp285SetPos v',version])
     disp(['-------------------------------']);
     disp([' usage: mp285SetPos([x y z])'])
     error(['### incomplete or ambiguous parameters; cannot proceed']); 
end 

if length(state.motor.serialPortHandle) == 0
	disp(['mp285SetPos: mp285 not configured']);
	state.motor.lastPositionRead=[];
	out=1;
	return;
end
 
% convert microns to units of nm  mod resolution (i.e. 100nm resolution);
xyz2=fix(xyz*10).*[state.motor.calibrationFactorX state.motor.calibrationFactorY state.motor.calibrationFactorZ];

% flush all the junk out
mp285Flush;
state.motor.movePending=1;
state.motor.requestedPosition=xyz;
% send move command
try
	fwrite(state.motor.serialPortHandle, 'm');
	fwrite(state.motor.serialPortHandle, xyz2, 'long');
	fwrite(state.motor.serialPortHandle, 13);
catch
	disp('mp285StartMove: mp285 communication error');
end
