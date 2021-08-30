function ivExportObjectComments(prefix, outputFile)
	global state
	if nargin<2
		[filename, pathname] = uiputfile('*.itx', 'Save Object Comments Wave As');
		if isnumeric(filename)
			return
		end
		outputFile=fullfile(pathname, filename);
	end
	if isempty(find(outputFile=='.'))
		outputFile=[outputFile '.itx'];
	end

	if nargin<1
		prefix='';
	end
	
	stringCell={};
	
	for counter=1:length(state.imageViewer.objStructs)
		stringCell{counter}=state.imageViewer.objStructs(counter).text;
	end
	[fid, message] = fopen(outputFile, 'w');
	if fid==-1
		message
		error(['exportStringCellWave : could not open ' outputFile ' for output']);
	end
	
	fprintf(fid, 'IGOR\n');
	
	ewWriteStringCell(fid, stringCell, 'comments' , prefix);	
	fclose(fid);