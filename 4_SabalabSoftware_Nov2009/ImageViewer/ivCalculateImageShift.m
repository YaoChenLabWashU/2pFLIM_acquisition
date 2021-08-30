function ivCalculateImageShift(recalc)
	if nargin<1
		recalc=1;
	end
	
	global state
	
	try
		state.imageViewer.trackerImage=double(state.imageViewer.projectionDataAll{3, state.imageViewer.morphChannel});
		state.imageViewer.trackerImageXZ=double(state.imageViewer.projectionDataAll{2, state.imageViewer.morphChannel});
		state.imageViewer.trackerImageYZ=double(state.imageViewer.projectionDataAll{1, state.imageViewer.morphChannel});
		
		if recalc 
			disp('Finding shifts ...');
			shift=ivFindShift(state.imageViewer.trackerReference, state.imageViewer.trackerImage);
			if length(size(state.imageViewer.tsStackData{state.imageViewer.tsFileCounter, state.imageViewer.morphChannel}))>=3
				state.imageViewer.pixelShiftY=shift(1)-state.imageViewer.trackerY0+1;
				state.imageViewer.pixelShiftX=shift(2)-state.imageViewer.trackerX0+1;
				shift=ivFindShift(state.imageViewer.trackerReferenceXZ, state.imageViewer.trackerImageXZ);
			else
				shift=[0 0  0];
			end

			state.imageViewer.pixelShiftZ=shift(2);
			
		else
			disp('Applying Shifts...');
		end

		updateGUIByGlobal('state.imageViewer.pixelShiftX');
		updateGUIByGlobal('state.imageViewer.pixelShiftY');
		updateGUIByGlobal('state.imageViewer.pixelShiftZ');
		ivUpdateReferenceImage;
	catch
		disp('*** ivCalculateImageShift: Error in autoTrack  ');
		disp(lasterr);
	end

	