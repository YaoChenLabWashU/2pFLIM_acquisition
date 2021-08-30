function ivInterpImage(filename, outfile)

	if nargin<1
		[fname, pname] = uigetfile({'*.tif;'}, 'Choose stack to load');
		if ~isnumeric(fname)
			filename = [pname fname];
		else
			return
		end
	end

	try
		[path,name,ext] = fileparts(filename);
		cd(path);
		
		disp(['*** IN = ' filename]);
		stackHeader = readImageHeaderTif(filename);
		initialImage = opentif(filename);
	
		if nargin<2
			outfile=fullfile(path, [name '_int' ext]);
		end
		disp(['*** OUT = ' outfile]);
		
		xdInitial=512;
		ydInitial=512;
	
		interFactor=0.082/0.125;
		xdOut=512;
		ydOut=512;
		
		X=1:512;
		Y=1:512;
			
		[XI, YI]=meshgrid(1:interFactor:(1+(xdOut-1)*interFactor), 1:interFactor:(1+(ydOut-1)*interFactor));
		
		for frameCounter=1:size(initialImage, 3) % Loop through all the frames
			disp(['frame ' num2str(frameCounter)]);
			outData=round(interp2(X, Y, double(initialImage(:, :, frameCounter)), XI, YI));
			if frameCounter==1
				imwrite(uint16(outData), outfile,  'WriteMode', 'overwrite', 'Compression', 'none', 'Description', stackHeader);
			else
				imwrite(uint16(outData), outfile,  'WriteMode', 'append', 'Compression', 'none');
			end	
		end
	catch
		disp(['	ERROR: ivInterpImage : ' lasterr])
	end
