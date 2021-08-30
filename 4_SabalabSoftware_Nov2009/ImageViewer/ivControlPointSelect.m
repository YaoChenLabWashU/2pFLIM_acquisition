function ivControlPointSelect
	global state
	if state.imageViewer.selectionChannel<=4
		figure(state.imageViewer.figure(state.imageViewer.selectionChannel));
	elseif state.imageViewer.selectionChannel<=8
		figure(state.imageViewer.projFigure(state.imageViewer.selectionChannel-4));
	elseif state.imageViewer.selectionChannel==9
		figure(state.imageViewer.compositeFigure);
	end
	
	[Y,X]=ginput;
	
	if isempty(X)
		return
	end
	state.imageViewer.multiReferenceAll=double(get(gco, 'CData'));

	X=round(X);
	Y=round(Y);
	state.imageViewer.multiReferenceCoords=[X, Y];
	state.imageViewer.multiReferences=cell(1, length(X));
	for counter=1:length(X);
		state.imageViewer.multiReferenceImages{counter}=...
			state.imageViewer.multiReferenceAll...
			(X(counter)-state.imageViewer.multiReferenceSpan:X(counter)+state.imageViewer.multiReferenceSpan, ...
			Y(counter)-state.imageViewer.multiReferenceSpan:Y(counter)+state.imageViewer.multiReferenceSpan);
	end
	