function saveNotebooks(counter)
	if nargin<1
		counter=[1 2];
	end
	
	global state
	names={'mynotes', 'autonotes'};
	
	if ~isempty(state.files.savePath)
		for n=counter
			notebook=getfield(state.notebook, ['notebookText' num2str(n)]);
			save(fullfile(state.files.savePath, names{n}), 'notebook');
		end
	end
