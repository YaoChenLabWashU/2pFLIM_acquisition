function timerSetActiveStatus(packageList, status)
	if nargin<2
		status=1;
	end
	if nargin<1
		error('timerSetActiveStatus: please provide package name');
	end;

	if isempty(packageList)
		return
	end
	
	indexList=timerGetPackageListIndices(packageList);
	if isempty(indexList)
		disp(['timerSetActiveStatus: no valid packages: ' packageList]);
		return
	end
	
	global state gh
	for index=indexList
		state.timer.activePackages(index)=status;
		if status	% package was turned on;  if not initialized, then do it now
			if ~state.timer.initializedPackages(index)
				timerCallPackageFunctions('Init', index);
				state.timer.initializedPackages(index)=1;
			end	
		end

		if ishandle(gh.timerMainControls.Packages)	% set the flag in the menu
			menuIndex=length(state.timer.packageList)-index+1;
			children=get(gh.timerMainControls.Packages, 'Children');
			if status
				set(children(menuIndex), 'Checked', 'on');
			else
				set(children(menuIndex), 'Checked', 'off');
			end
		end
	end