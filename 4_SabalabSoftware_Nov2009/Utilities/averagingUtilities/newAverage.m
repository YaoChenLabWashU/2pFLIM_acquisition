function newAverage(name)
% function that creates a new average
	if ~ischar(name)
		name=inputname(name);
	end
	
	if ~iswave(name)
		wave(name, []);
	end
	resetAverage(name);		