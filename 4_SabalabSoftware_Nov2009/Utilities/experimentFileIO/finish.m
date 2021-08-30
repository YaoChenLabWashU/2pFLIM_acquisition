function finish
    %TN Apr 05
    try
        pzGoto(0);
    catch
    end
    
    try
        if(state.db.conn~=0)
            saveNotebooksToDB
            disconnectDB
        end
    catch
    end
    
    try
        state.internal.NeverSaveExperiment;
    catch
    button = questdlg('Would you like to save the experiment?', ...
		'Save?','Yes','No','Cancel','Yes');
	switch button
		case 'Yes',
			saveExperiment;
		case 'Cancel',
			quit cancel;
	end
end