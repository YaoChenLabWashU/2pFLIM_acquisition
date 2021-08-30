function ivSaveInformation(fields, outputFile)
	global state
	if nargin<2
		[filename, pathname] = uiputfile('*.mat', 'Save setup as');
		if isnumeric(filename)
			return
		end
		outputFile=fullfile(pathname, filename);
	end
	if isempty(find(outputFile=='.'))
		outputFile=[outputFile '.mat'];
	end
	
	tempObject=[];
	
	disp('Collecting fields...')
	for fieldName=fields		
		disp(['tempObject.'	fieldName{1} ' = state.imageViewer.' fieldName{1} ';']);
		eval(['tempObject.'	fieldName{1} ' = state.imageViewer.' fieldName{1} ';']);
	end
	
	disp(['Saving ' outputFile '...'])
	save(outputFile, 'tempObject');
	clear tempObject
	disp('Done')
	
