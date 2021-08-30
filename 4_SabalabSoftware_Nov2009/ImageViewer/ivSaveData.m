function ivSaveData(outputFile)
	global state
	
	if nargin<1
		ivSaveInformation(state.imageViewer.currentDataFields);
	else
		ivSaveInformation(state.imageViewer.currentDataFields, outputFile);
	end		
	
		
