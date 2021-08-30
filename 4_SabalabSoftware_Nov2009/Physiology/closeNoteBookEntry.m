function closeNoteBookEntry
	global gh state
	
	hideGUI('gh.notebookLine.figure1');
	state.notebook.newEntry='';
	updateGUIByGlobal('state.notebook.newEntry');