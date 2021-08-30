function ivClearAxisHandles(axisNumbers)
	global state
return
	if nargin<1
		axisNumbers=1:length(state.imageViewer.axis);
	end
	
	for counter=axisNumbers
		try
			c=get(state.imageViewer.axis(counter), 'Children');
			delete(c(1:end-1));
		catch
		end
		try
			c=get(state.imageViewer.projAxis(counter), 'Children');
			delete(c(1:end-1));
		catch
		end
	end