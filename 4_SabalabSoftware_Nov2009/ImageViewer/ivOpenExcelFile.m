function ivOpenExcelFile
	global state

	[fname, pname] = uigetfile('*.xls', 'Choose Excel File to Open...');
	if pname == 0
		return
	else
		state.imageViewer.excelFileName = [pname fname];
		eval([' ! ' state.imageViewer.excelFileName '&']); 
	end

	button = questdlg(['Do you want to connect to ' [pname fname] '?'] ,...
	'Wait For File To Load Before Connecting!','Yes', 'No','Yes');
	if strcmp(button,'Yes')
		try
			state.imageViewer.excelChannel = ddeinit('excel', state.imageViewer.excelFileName);
		catch
			disp('Not a valid File name');
			state.imageViewer.excelChannel=[];
			return
		end
	elseif strcmp(button,'No')
	   return
	end


	
	moreParams={' ', 'morph chan', 'sel chan', 'offset mode', 'smooth', 'width', 'sel #', 'x1', 'y1', 'x2', 'y2', 'mask pixels'};
	moreParams2={' ', 'ana chan', 'offset', 'min', 'max', 'avg', 'pixels', 'mask avg'};

	params=[state.imageViewer.fieldsForExcelLabels moreParams moreParams2 moreParams2 moreParams2];
	for col=1:size(params, 2)
		ddepoke(state.imageViewer.excelChannel, ['r9c' num2str(col)], params{col});
	end
	state.imageViewer.excelRow=10;

