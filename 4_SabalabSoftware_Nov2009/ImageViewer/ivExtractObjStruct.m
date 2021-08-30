function ivExtractObjStruct(fileName)

	global state
	load(fileName);
	state.imageViewer.objStructs=tempObject.objStructs;
