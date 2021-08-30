 
function out=mp285SetPos(xyz, resolution, checkPosition)
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

out=1;
global state
if state.motor.motorOn==0
	return
end

if nargin < 1
     disp(['-------------------------------']);  
     disp([' mp285SetPos v',version])
     disp(['-------------------------------']);
     disp([' usage: mp285SetPos([x y z])']);
     error(['### incomplete parameters; cannot proceed']); 
end 

if nargin < 2
     resolution=state.motor.resolution;
end

if nargin < 3
	checkPosition=1;
end

if isempty(resolution)
     resolution=state.motor.resolution;
end

if isempty(checkPosition)
	checkPosition=1;
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
xyz2=fix(xyz*state.motor.resolution).*	...
	[state.motor.calibrationFactorX state.motor.calibrationFactorY state.motor.calibrationFactorZ];

% flush all the junk out
mp285Flush;

% temp=mp285Comp14ByteArr(xyz);
try
	fwrite(state.motor.serialPortHandle, 'm');
    % gy 201204 changed following from 'long' to 'int32'
	fwrite(state.motor.serialPortHandle, xyz2, 'int32');
	fwrite(state.motor.serialPortHandle, 13);
	out=fread(state.motor.serialPortHandle,1);
catch
	disp(['mp285SetPos: mp285 communication eror.']);
	return
end

if out ~= 13; 
	disp(['mp285SetPos: mp285 return an error.  Unsure of movement status.']); 
	mp285Flush;
	state.motor.lastPositionRead=[];
	out=1;
	return;
end				% check if CR was returned

% check if position was attained
if checkPosition
	xyzN=mp285GetPos;
	if isempty(xyzN)
		disp(['mp285SetPos: Unable to check movement.']);
	elseif fix(xyz*state.motor.resolution) ~= fix(xyzN*state.motor.resolution); 
		disp(['mp285SetPos: Requested position not attained; check hardware']);
		state.motor.lastPositionRead=[];
		out=1;
		return;
	end		
end

out=0;



