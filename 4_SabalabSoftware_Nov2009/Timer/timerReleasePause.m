function timerReleasePause(package)
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
	
	for counter=1:length(indexList)
		state.timer.pausedPackages(indexList(counter))=0;
	end
	
	if ~any(state.timer.pausedPackages) & state.cycle.loopingStatus==2
		timerMainLoop;
	end