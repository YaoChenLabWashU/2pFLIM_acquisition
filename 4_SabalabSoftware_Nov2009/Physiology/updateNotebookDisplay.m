function updateNotebookDisplay
	global state 
	
	state.notebook.linePositionFlip=1001-state.notebook.linePosition+1;
	updateGUIByGlobal('state.notebook.linePositionFlip');
	
	if ~iscell(eval(['state.notebook.notebookText' num2str(state.notebook.notebookNumber)]))
		eval(['state.notebook.notebookText' num2str(state.notebook.notebookNumber) '={};'])
	end
	
	notebookSize=eval(['size(state.notebook.notebookText' num2str(state.notebook.notebookNumber) ',2)']);
	
	for counter=1:7
		eval(['state.notebook.pos' num2str(counter) ...
				'=counter+state.notebook.linePosition-1;']);
		updateGUIByGlobal(['state.notebook.pos' num2str(counter)]);
		if notebookSize<(state.notebook.linePosition+counter-1)
			eval(['state.notebook.line' num2str(counter) ...
					'='''';']);
		else
			eval(['state.notebook.line' num2str(counter) ...
					'=state.notebook.notebookText' ...
					num2str(state.notebook.notebookNumber) ...
					'{state.notebook.linePosition+counter-1};']);
		end
		updateGUIByGlobal(['state.notebook.line' num2str(counter)]);
	end