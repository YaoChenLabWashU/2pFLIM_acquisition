function exportStringCellWave(stringCell, prefix, outputFile)

	if ~iscell(stringCell)
		error('exportStringCellWave : expect wave name or cell array of wave names as input');
	end
	
	if nargin<3
		[filename, pathname] = uiputfile('*.itx', 'Save wave as');
		if isnumeric(filename)
			return
		end
		outputFile=fullfile(pathname, filename);
	end
	if isempty(find(outputFile=='.'))
		outputFile=[outputFile '.itx'];
	end

	if nargin<2
		prefix='';
	end
	
	[fid, message] = fopen(outputFile, 'w');
	if fid==-1
		message
		error(['exportStringCellWave : could not open ' outputFile ' for output']);
	end
	
	fprintf(fid, 'IGOR\n');
	
	ewWriteStringCell(fid, stringCell, inputname(1), prefix);	
	fclose(fid);