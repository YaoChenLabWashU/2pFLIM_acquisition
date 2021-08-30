function timerSetPackageStatus(status, package)
	global state
	
	if nargin==2
		if isempty(package)
			return
		elseif iscell(package)
			indexList=find(strcmp(state.timer.packageList, package));
		elseif isnumeric(package) && (~isempty(package))
			indexList=package;
		elseif ischar(package)
			indexList=find(strcmp(state.timer.packageList, package));
		else
			disp('timerSetPackageStatus: package is of unknown type');
			return
		end
	else
		indexList=[1:length(state.timer.packageList)];
	end
	
	state.timer.status=status;
	for counter=1:length(indexList)
		if state.timer.activePackages(indexList(counter)) 
			state.timer.packageStatus(indexList(counter))=status;
		end
	end