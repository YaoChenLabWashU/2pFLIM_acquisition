function exportMemoryToIgor(prefix, template, clearFromMemory, avgMode, sizeLimit)
% exportMemoryToIgor(prefix, template, clearFromMemory, forceDisk, avgMode, sizeLimit)
%
% This function takes all WAVES in memory and exports them
% into Igor Pro WAVE TEXT FILE format.
%
% See HELP exportAllToIgor for details on the paramater definitions
%
% This function is equivalent to 
%	exportAllToIgor(prefix, template, clearFromMemory, avgMode, -1)
%
% 
	switch nargin
		case 0
			exportAllToIgor('', '', 0, 1, -1);
		case 1
			exportAllToIgor(prefix, '', 0, 1, -1);
		case 2
			exportAllToIgor(prefix, template, 0, 1, -1);
		case 3
			exportAllToIgor(prefix, template, clearFromMemory, 1, -1);
		case 4
			exportAllToIgor(prefix, template, clearFromMemory, avgMode, -1);
		case 5
			exportAllToIgor(prefix, template, clearFromMemory, avgMode, -1, sizeLimit);
		otherwise
			error('exportMemoryToIgor: wrong number of arguments')
	end
