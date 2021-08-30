function ivMarkObjectHere(objectNumber)
	global state
	
	if nargin<1
		objectNumber=state.imageViewer.currentObject;
	end
	
	if isempty(objectNumber)
		objectNumber=state.imageViewer.currentObject;
	end	
	timePoint=state.imageViewer.tsFileCounter;
	
	state.imageViewer.objStructs(objectNumber).status(timePoint)=1;

	ivHighlightObject;