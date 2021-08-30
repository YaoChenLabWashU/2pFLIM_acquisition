function sendMaxToReference(chan)
	global state projectionData

	if nargin<1
		chan=2;
	end
	
	try
		if ~ishandle(state.internal.refImage) | ~ishandle(state.internal.refFigure)
			return
		end
		if ~strcmp('on', get(state.internal.refFigure, 'Visible'))
			return
		end
		
		startImage=	zeros(state.acq.linesPerFrame, state.acq.pixelsPerLine, 3);
			startImage(:,:,1) = ...
				min(max(...
				(projectionData{chan} - ...
				getfield(state.internal, ['lowPixelValue' num2str(chan)])) / ...
				max(...
					getfield(state.internal, ['highPixelValue' num2str(chan)]) ...
					-getfield(state.internal, ['lowPixelValue' num2str(chan)])...
					,1)...
				,0)...
				,1);
		set(state.internal.refImage, 'CData', startImage);
    catch
		disp(['sendMaxToReference : ' lasterr]);
    end
