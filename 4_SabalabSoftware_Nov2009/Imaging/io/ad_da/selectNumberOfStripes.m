function selectNumberOfStripes; % Function that selects the number of stripes appropriate for the given image size.
global state gh

% This function sets the state.acq.numberOfStripes parameter to the appropriate value,
% depending on whether the lines per frame is small or large.
%
% Written By: Thomas Pologruto
% Cold Spring Harbor Labs
% January 31, 2001
	
%Selection of Number of Stripes


switch sum([state.acq.imagingChannel1 state.acq.imagingChannel2 state.acq.imagingChannel3])
case 1
	
	switch state.acq.linesPerFrame
	case 32
		state.internal.numberOfStripes = 1;
	case 64
		state.internal.numberOfStripes = 2;
	case 128
		state.internal.numberOfStripes = 4;
	case 256
		state.internal.numberOfStripes = 8;
	otherwise
		state.internal.numberOfStripes = 16;
	end
		
	
case 2
	switch state.acq.linesPerFrame
	case 32
		state.internal.numberOfStripes = 1;
	case 64
		state.internal.numberOfStripes = 2;
	case 128
		state.internal.numberOfStripes = 4;
	case 256
		state.internal.numberOfStripes = 8;
	otherwise
		state.internal.numberOfStripes = 16;
	end
		
case 3
	switch state.acq.linesPerFrame
	case 32
		state.internal.numberOfStripes = 1;
	case 64
		state.internal.numberOfStripes = 2;
	case 128
		state.internal.numberOfStripes = 4;
	otherwise
		state.internal.numberOfStripes = 8;
	end
	
otherwise
end
	