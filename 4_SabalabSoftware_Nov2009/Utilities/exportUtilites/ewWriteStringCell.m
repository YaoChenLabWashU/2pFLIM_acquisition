function ewWriteStringCell(fid, data, cellName, prefix)
	if nargin<3
		prefix='';
	end
	
	if ~isempty(prefix)
		prefix=[prefix '_'];
	end
	
	if size(data, 1)>1
		fprintf(fid, 'WAVES/T/n=(%e,%e) %s\nBEGIN\n', size(data,2), size(data,1), [prefix cellName]);
	else
		fprintf(fid, 'WAVES/T %s\nBEGIN\n', [prefix cellName]);
	end
	for counter=1:size(data, 2)
		if size(data, 1)>1
			for c2=1:size(data, 1)
				if ischar(data{c2, counter})
					fprintf(fid, '   "%s"', data{c2, counter});
				else
					fprintf(fid, '   ""', data{c2, counter});
				end
			end
			fprintf(fid, '\n');
		else			if ischar(data{counter})
				fprintf(fid, '   "%s"\n', data{counter});
			else
				fprintf(fid, '   ""\n', data{counter});
			end
		end
	end
	fprintf(fid, 'END\n');	

	fprintf(fid, '\n');
