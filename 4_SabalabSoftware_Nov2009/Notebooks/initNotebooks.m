function initNotebooks
	global state gh

	gh.notebook=guihandles(notebook);
	gh.notebookLine=guihandles(notebookline);
	hideGUI('gh.notebookLine.figure1');
	openini('notebook.ini');
	state.notebook.notebookText={''};
	