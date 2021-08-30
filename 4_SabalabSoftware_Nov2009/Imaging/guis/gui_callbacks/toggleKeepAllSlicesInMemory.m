function toggleKeepAllSlicesInMemory
% BSMOD - 1/1/2 - callback when user selects 'keepAllSlicesInMemory' from 'settings' menu

    global gh state
	% get the index of the standard mode selection of the settings menu
	children=get(gh.siGUI_ImagingControls.Settings, 'Children');			
	index=getPullDownMenuIndex(gh.siGUI_ImagingControls.Settings, 'Keep all slices in memory');
	
	checkState=get(children(index), 'Checked'); % check state of check mark nexted to 'autosave' option

    if strcmp(checkState,'on')     % it is on, so turn it off
        state.internal.keepAllSlicesInMemory=0;
    else
        state.internal.keepAllSlicesInMemory=1;
    end
    
	preallocateMemory;
    updateKeepAllSlicesCheckMark;
    
       