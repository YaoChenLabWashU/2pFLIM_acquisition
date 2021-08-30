function ivBringSelectionToFront(projOnly)

	if nargin<1
		projOnly=0;
	end
	
	global state
	if state.imageViewer.selectionChannel==0
		figure(state.imageViewer.compositeFigure)
	else
		if state.imageViewer.selectionChannelIsProj | projOnly
			figure(state.imageViewer.projFigure(state.imageViewer.selectionChannel));
		else		
			figure(state.imageViewer.figure(state.imageViewer.selectionChannel));
		end
	end
