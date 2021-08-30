function ivApplyShiftToLines
	global state
	
	for counter=1:length(state.imageViewer.lineHandles)
		try
			x=get(state.imageViewer.lineHandlesRef(counter), 'XData');
			y=get(state.imageViewer.lineHandlesRef(counter), 'YData');
			set(state.imageViewer.lineHandles(counter), ...
				'YData', y+state.imageViewer.pixelShiftY, ...
				'XData', x+state.imageViewer.pixelShiftX);
		catch
		end
	end
