function timerOpenExcel
	global state
	[fname, pname] = uigetfile('*.xlsx', 'Choose Excel File to Open...');
	if pname == 0
		return
	else
		state.internal.excelFileName = fname;
		state.internal.excelPathName = pname;
		eval([' ! ' fullfile(pname, fname) '&']); 
	end
	button = questdlg(['Do you want to connect to ' [pname fname] '?'] ,...
		'Wait For File To Load Before Connecting!','Yes', 'No','Yes');
	state.internal.excelChannel=[];
	if strcmp(button,'Yes')
		state.internal.excelChannel = ddeinit('excel', fname);
		timerFormatExcel;
	elseif strcmp(button,'No')
       return
	end
