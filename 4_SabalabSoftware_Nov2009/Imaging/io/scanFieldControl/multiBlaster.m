function multiBlaster

	global state;


        setStatusString('Click on blaster locations');
		siSelectionChannelToFront

    %locs=ginput;
    %state.blaster.multiLocs=locs;
    
    %for i=1:size(locs,1)
    %    addNewBlasterPosByScreenXY(locs(i, 1), locs(i,2));
    %end
    
    pos=ginput(1);
    
    while (length(pos)>0)
        state.blaster.multilocs(size(state.blaster.multilocs, 1)+1, 1)= pos(1);
        state.blaster.multilocs(size(state.blaster.multilocs,1), 2)= pos(2);
        addNewBlasterPosByScreenXY(pos(1), pos(2));
        updateReferenceImage
        pos=ginput(1);
    end
    
    setupBlasterConfigsByPos(22)
    makeBlasterConfigMenu
    updateReferenceImage
    
    %%%
   