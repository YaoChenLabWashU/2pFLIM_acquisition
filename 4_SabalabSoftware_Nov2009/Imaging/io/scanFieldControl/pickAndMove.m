function pickAndMove
	global state

	try
		setStatusString('Click on center');
		siSelectionChannelToFront

		[x,y]=ginput(1);
		if isempty(findobj(gcf, 'Type', 'axes'))
			disp('*** NO axes***');
			set(hObject, 'Enable', 'on');	
			return
		end
	
		index = round(y-1) * state.internal.lengthOfXData + ...
			round(state.internal.lengthOfXData*(state.internal.fractionStart+x*state.internal.fractionPerPixel));
	
		
        shiftX = (state.acq.repeatedMirrorData(index,1) - state.acq.scanOffsetX)*state.internal.unitFieldSizeX
		shiftY = (state.acq.repeatedMirrorData(index,2) - state.acq.scanOffsetY)*state.internal.unitFieldSizeY

        try
            handleScanChange;
        catch
            disp(['*** ERROR in handleScanChange: ' lasterr]);
        end
	catch
 		disp(['*** ERROR in selection: ' lasterr]);
	end		