function out=ivLoadInformation(fields, inputFile)
	global state

	out=0;
	if nargin<2
		[filename, pathname] = uigetfile('*.mat', 'Save setup as');
		if isnumeric(filename)
			return
		end
		inputFile=fullfile(pathname, filename);
	end
	if isempty(find(inputFile=='.'))
		inputFile=[inputFile '.mat'];
	end
	
	tempObject=load(inputFile);

	disp(['Restoring fields from ' inputFile ' ...'])
	for fieldName=fields
		try
			eval(['state.imageViewer.'	fieldName{1} ' = tempObject.tempObject.' fieldName{1} ';']);
			updateGUIByGlobal(['state.imageViewer.'	fieldName{1}]);
		catch
			disp(['ivLoadInformation: Error restoring ' fieldName{1}]);
		end
	end

	disp('Done')
	clear tempObject
	out=1;
	
	