function exportWave(waveList, prefix, outputFile)

	if iswave(waveList)
		if ~iscell(waveList) & ~ischar(waveList) 
			waveList=inputname(1);
		end
	else
		error('exportWave : expect wave name or cell array of wave names as input');
	end
	
	if ischar(waveList)
		waveList={waveList};
	end

	if nargin<2
		prefix='';
	end
	
	if nargin<3
		if length(prefix)==0
			p2='*';
		else
			p2=prefix;
		end
		[filename, pathname] = uiputfile([p2 '.itx'], 'Save wave as');
		if isnumeric(filename)
			return
		end
		outputFile=fullfile(pathname, filename);
	end

	if isempty(find(outputFile=='.'))
		outputFile=[outputFile '.itx'];
	end

	[fid, message] = fopen(outputFile, 'w');
	if fid==-1
		message
		error(['exportWave : could not open ' outputFile ' for output']);
	end
	
	fprintf(fid, 'IGOR\n');
	
	for name=waveList
		if iswave(name{1})
			ewWriteData(fid, name{1}, prefix);	
		else
			disp(['exportWave : ' name{1} ' does not exist or is not a wave or a cellarray.  Skipping...']);
		end
	end
	fclose(fid);