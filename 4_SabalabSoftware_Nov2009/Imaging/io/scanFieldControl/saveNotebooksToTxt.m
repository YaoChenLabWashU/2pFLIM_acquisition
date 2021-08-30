function saveNotebooksToTxt(counter)
	if nargin<1
		counter=[1 2];
	end
	
	global state
	names={'mynotes.txt', 'autonotes.txt'};
	
	if ~isempty(state.files.savePath)
		for n=counter
			notebook=getfield(state.notebook, ['notebookText' num2str(n)]);
          
             fid=fopen(fullfile(state.files.savePath, names{n}), 'w');
             for line=1:size(notebook,2)
                 mycell=notebook(1, line);
                 fprintf(fid, '%s\r\n', mycell{1});
             end
             fclose(fid);
			%save(fullfile(state.files.savePath, names{n}), 'notebook');
		end
	end
