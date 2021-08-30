function addEntryToNotebook(notebookNumber, entry, update)
% Adds line to end of notebook 
% addEntryToNotebook(notebookNumber, entry)

	global state
	
	if nargin<3
		update=1;
	end
	
    
    
	eval(['state.notebook.notebookText' num2str(notebookNumber) ...
			'{end+1}=entry;']);

	if (notebookNumber==state.notebook.notebookNumber) && update
		newMax=max( ...
			eval(['size(state.notebook.notebookText'  num2str(state.notebook.notebookNumber) ',2)-6']) ...
			,1);
		if newMax>state.notebook.linePosition
			state.notebook.linePosition=newMax;
		end
		updateNotebookDisplay;
	end
	if state.files.autoSave && ~isempty(state.files.savePath)
		saveNotebooks(notebookNumber);
	end

 