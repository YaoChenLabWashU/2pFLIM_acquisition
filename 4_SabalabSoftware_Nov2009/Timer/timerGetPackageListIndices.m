function packageIndices=timerGetPackageListIndices(packageList)
	if nargin<1
		error('timerGetPackageListIndices: please provide package name');
	end;
	
	if isnumeric(packageList)
		packageIndices=packageList;
	elseif ischar(packageList)
		packageIndices=timerPackageIndex(packageList);
	elseif iscell(packageList)
		packageIndices=[];
		for package=packageList
			if ischar(package{1})
				index=timerPackageIndex(package{1});
				if ~isempty(index)
					packageIndices(end+1)=index;
				end
			elseif isnumeric(package{1}) && ~isempty(package{1})
				packageIndices(end+1)=package{1};
			else
				error('timerGetPackageListIndices: Invalid data type in packageList cell array');				
			end
		end
	end
	
	