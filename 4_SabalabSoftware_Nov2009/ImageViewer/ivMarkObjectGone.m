function ivMarkObjectGone(objectNumber)
	global state
	
	if nargin<1
		objectNumber=state.imageViewer.currentObject;
	end
	
	if isempty(objectNumber)
		objectNumber=state.imageViewer.currentObject;
	end	
	timePoint=state.imageViewer.tsFileCounter;

	state.imageViewer.objStructs(objectNumber).width(timePoint)=0;
	state.imageViewer.objStructs(objectNumber).length(timePoint)=0;
	state.imageViewer.objStructs(objectNumber).max(timePoint)=0 ;
	state.imageViewer.objStructs(objectNumber).status(timePoint)=3;

	ivHighlightObject;