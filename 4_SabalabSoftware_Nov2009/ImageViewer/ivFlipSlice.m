function ivFlipSlice(sliceNumber, force)
	global state
	
	if nargin<2
		force=0;
	end
	
	if nargin<1
		sliceNumber=state.imageViewer.displayedSlice;
	end
	
	if (state.imageViewer.displayedSlice~=sliceNumber) | force
		state.imageViewer.displayedSlice=sliceNumber;
		ivUpdateFigures;
	end
