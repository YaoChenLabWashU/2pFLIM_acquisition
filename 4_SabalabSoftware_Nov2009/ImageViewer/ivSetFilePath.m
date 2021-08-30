function ivSetFilePath
	global state

	[fname, pname] = uiputfile('path', 'Choose data path...');
	if pname == 0
		return
	else
		state.imageViewer.filePath = pname;
	end
