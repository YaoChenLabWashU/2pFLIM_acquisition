function loadNotebooks(counter)
	if nargin<1
		counter=[1 2];
	end
	
	global state
	names={'mynotes', 'autonotes'};
	
	if isempty(state.files.savePath)
		disp('*** saveNotebooks : Unable to  notebooks -- please set save path.');
	else
		for n=counter
			load(fullfile(state.files.savePath, names{n}));
			eval(['state.notebook.notebookText' num2str(n) '=notebook;']);
			updateNotebookDisplay;
		end
	end
