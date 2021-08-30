function out=timerPausedStatus(package)
	global state gh

	if nargin==1
		if iscell(package)
			indexList=find(strcmp(state.timer.packageList, package));
		elseif isnumeric(package) & ~isempty(package)
			indexList=package;
		elseif ischar(package)
			indexList=find(strcmp(state.timer.packageList, package));
		else
			disp('timerRequestPause: package is of unknown type');
		end
	else
		indexList=[1:length(state.timer.packageList)];
	end
	
	out=any(state.timer.pausedPackages(indexList));
