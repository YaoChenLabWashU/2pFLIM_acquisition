function status=timerPackageIsInitialized(package)
% returns true if specified package(s) initialized
% gy 201208
global state
	status=0;
	
	if nargin==1
		if iscell(package)
			indexList=find(strcmp(state.timer.packageList, package));
		elseif isnumeric(package) && ~isempty(package)
			indexList=package;
		elseif ischar(package)
			indexList=find(strcmp(state.timer.packageList, package));
		else
			disp('timerPackageIsInitialized: package is of unknown type');
		end
	else
		indexList=[1:length(state.timer.packageList)];
	end
	
	status=state.timer.initializedPackages(indexList);
