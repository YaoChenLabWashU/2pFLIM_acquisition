function cycleLaser(table1,cycOffset)
% cycles Laser Wavelength, Scan Power, and Num Frames
% through a table, using the (file number minus the 
% cycOffset) modulo the table length
global state
% table:  
%   wlen1 power1 nframes1
%   wlen2 power2 nframes2
%   wlen3 power3 nframes3
%   ...
if nargin<2
    cycOffset=0;
end

% first figure out which row of the table we're on:
len=size(table1,1);  % number of rows
idx=1+(mod(state.files.lastAcquisition-cycOffset,len));

tuneLaser(table1(idx,1));
%disp(['laser to ' num2str(table1(idx,1))]); % test line

state.pcell.pcellScanning1 = table1(idx,2);
updateGUIByGlobal('state.pcell.pcellScanning1');
state.pcell.pcellScanning2 = table1(idx,4);
%BAM added line
updateGUIByGlobal('state.pcell.pcellScanning2');
%BAM added line
state.internal.needNewPcellPowerOutput=1;

try
	applyChangesToOutput;
catch lastErrCode
	disp(['error in apply pcell change : ' lastErrCode]);
end;  %added gy 20111031

state.cycle.frames = table1(idx,3);
updateGUIByGlobal('state.cycle.frames');