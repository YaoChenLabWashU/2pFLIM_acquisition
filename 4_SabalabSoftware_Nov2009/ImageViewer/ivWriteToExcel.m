function ivWriteDataToExcel(writeParams, increment, data, startCol)
	global state
	
	if isempty(state.imageViewer.excelChannel)
		beep;
		disp('*** Excel Link not open ***');
		return
	end

	if ~isnumeric(state.imageViewer.excelNextCol)
		state.imageViewer.excelNextCol=1;
	end
	if nargin==4
		state.imageViewer.excelNextCol=startCol;
	end
	if nargin<3
		data=[];
	end
	if nargin<2
		increment=1;
	end
	if nargin<1
		writeParams=1;
	end
	
	try
		if writeParams
			for col=1:size(state.imageViewer.fieldsForExcel, 2)
				ddepoke(state.imageViewer.excelChannel, ...
					['r' num2str(state.imageViewer.excelRow) ...
						'c' num2str(col+state.imageViewer.excelNextCol-1)], ...
					getfield(state.imageViewer, state.imageViewer.fieldsForExcel{col}));
			end
			state.imageViewer.excelNextCol=state.imageViewer.excelNextCol+size(state.imageViewer.fieldsForExcel, 2);
		end
		
		if ~isempty(data)
			ddepoke(state.imageViewer.excelChannel, ['r' num2str(state.imageViewer.excelRow) 'c' num2str(state.imageViewer.excelNextCol) ...
					':r' num2str(state.imageViewer.excelRow) 'c' num2str(state.imageViewer.excelNextCol-1+size(data, 2))], data);
			if isnumeric(data)
				state.imageViewer.excelNextCol=state.imageViewer.excelNextCol + size(data, 2);
			else
				state.imageViewer.excelNextCol=state.imageViewer.excelNextCol + 1;
			end
		end
		
		if increment
			state.imageViewer.excelRow = state.imageViewer.excelRow + 1;
			state.imageViewer.excelNextCol=1;		
		end
		updateGUIByGlobal('state.imageViewer.excelRow');
	catch
		beep
		disp(['ivWriteDataToExcel : Caught error ' lasterr ])	
	end
	
