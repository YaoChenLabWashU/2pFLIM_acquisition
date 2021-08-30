function status=timerCallPackageFunctions(type, package)
	global state 
	
	if nargin==2
		if isempty(package)
			return
		elseif iscell(package)
			pList=package;
		elseif isnumeric(package) && (~isempty(package))
			pList=state.timer.packageList(package);
		elseif ischar(package)
			pList=state.timer.packageList(strcmp(state.timer.packageList, package));
		else
			disp('timerCallPackageFunctions: package is of unknown type');
		end
	else
		pList=state.timer.packageList;
	end
	
	if strcmp(type, 'Abort')
		state.timer.abort=1;
		pList=state.timer.packageList;
	end
	
	status=zeros(1, length(pList));
	setStatusString(type);
	
	for counter=1:length(pList)
		if state.timer.activePackages(timerPackageIndex(pList{counter})) 
			funcName=['timer' type '_' pList{counter}];
			if exist(funcName, 'file')==2
 %					disp(['CALLING:  ' funcName]);
				if nargout(funcName)==1
					status(counter)=eval(funcName);
				else
					eval(funcName);
					status(counter)=1;
				end
% 					disp(['           Done']);
			end
		else
			status(counter)=-1;
		end
			
	end

	if strcmp(type, 'Abort')
		timerCheckIfAllAborted
	end
