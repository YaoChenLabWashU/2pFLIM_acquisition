function saveNotebooksToDB(counter)
	if nargin<1
		counter=[1 2];
	end
	
	global state

    try
    
	if state.db.conn~=0
		for n=counter
			notebook=getfield(state.notebook, ['notebookText' num2str(n)]);
          
             for line=1:size(notebook,2)
                 mycell=notebook(1, line);
                 state.db.commentStr=mycell{1};
                 state.db.commentTime=datestr(now, 0);
                 state.db.commentSection=n;
                 addRecordByTable('cellComments');
             end
     
		end
	end
catch
end 