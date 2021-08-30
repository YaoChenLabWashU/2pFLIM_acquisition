function status=timerGetActiveStatus(package)
	global state
	status=0;
	
	if nargin==1
		if iscell(package)
			indexList=find(strcmp(state.timer.packageList, package));
		elseif isnumeric(package) & ~isempty(package)
			indexList=package;
		elseif ischar(package)
			indexList=find(strcmp(state.timer.packageList, package));
		else
			disp('timerGetActiveStatus: package is of unknown type');
		end
	else
		indexList=[1:length(state.timer.packageList)];
	end
	
	if isempty(indexList)
		status=0;
	else
		status=state.timer.activePackages(indexList);
	end
		
