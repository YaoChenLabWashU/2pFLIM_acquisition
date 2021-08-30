function makeTimerPackagesMenu
	global state gh
	
	children=get(gh.timerMainControls.Packages, 'Children');
	if ~isempty(children)
		delete(children);
	end
	
	if isempty(state.timer.packagesPath)
		state.timer.packagesPath=[fileparts(which('initTimer')) '\timerPackages'];
	end
	
	if ~isempty(state.timer.packagesPath)
		flist=dir(fullfile(state.timer.packagesPath, 'timerExists_*.m'));
		uimenu(gh.timerMainControls.Packages, 'Label', state.timer.packagesPath, 'Enable', 'off', 'Callback', 'setPackagesPath');
		
		for counter=1:length(flist)	
			packageName=flist(counter).name(13:end-2);
			if counter==1
				uimenu(gh.timerMainControls.Packages, 'Label', packageName, 'Callback', 'selectPackageFromMenu' ...
					, 'Separator', 'on');
				state.timer.packageList={packageName};
			else
				uimenu(gh.timerMainControls.Packages, 'Label', packageName, 'Callback', 'selectPackageFromMenu');
				state.timer.packageList=[state.timer.packageList packageName];
			end
		end
			
		state.timer.activePackages=zeros(1,length(flist));
		state.timer.packageStatus=zeros(1,length(flist));
		state.timer.initializedPackages=zeros(1,length(flist));
		state.timer.pausedPackages=zeros(1,length(flist));
    else
        disp(['makeTimerPackagesMenu : Error: Packages path ' state.timer.packagesPath ...
            ' not found']);
		uimenu(gh.timerMainControls.Packages, 'Label', 'Set package path...', 'Enable', 'on', 'Callback', 'setPackagesPath');
		state.timer.activePackages=[];
		state.timer.initializedPackages=[];
		state.timer.packageStatus=[];
		state.timer.packageList={};
		state.timer.pausedPackages=[];
	end		