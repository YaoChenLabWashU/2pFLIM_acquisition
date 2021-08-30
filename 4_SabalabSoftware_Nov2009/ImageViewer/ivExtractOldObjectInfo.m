function ivExtractOldObjectInfo(infile, outfile)

	if nargin<1
		[filename, pathname] = uigetfile('*.mat', 'Select experiment');
		if isnumeric(filename)
			return
		end
		infile=fullfile(pathname, filename);
	end
	if isempty(find(infile=='.'))
		infile=[infile '.mat'];
	end

	disp(['Loading from file ' infile '...']);
	ss=load(infile, '-mat', 'state');
	
	if isempty(ss)
		disp('    No state variable found');
		return
	elseif ~isfield(ss, 'state')
		disp('    No state variable found');
		return
	end		
	
	keepfields={...
			'tsFileNames', ...
			'tsFilePaths', ...
			'tsShift', ...
			'tsNumberOfFiles', ...
			'objectCenters', ...
            'objectStatus', ...
			'objectMajorAxisX', ...
			'objectMajorAxisY', ...
			'objectMinorAxisX', ...
			'objectMinorAxisY' ...
		};
	
	oldIV=struct;
	
	disp('Extracting fields...')
	for field=keepfields
		eval(['oldIV.' field{1} '=ss.state.imageViewer.' field{1} ';']);
	end
	
	clear ss
	
	numObjects=length(oldIV.objectCenters);

	global state
	state.imageViewer.tsFileNames=oldIV.tsFileNames;
	state.imageViewer.tsFilePaths=oldIV.tsFilePaths;
	state.imageViewer.tsShift=oldIV.tsShift;
	state.imageViewer.tsNumberOfFiles=oldIV.tsNumberOfFiles;
	state.imageViewer.objStructs=ivEmptyObjectStruct(state.imageViewer.tsNumberOfFiles);
	
	for objCounter=1:numObjects
		state.imageViewer.objStructs(objCounter)=ivEmptyObjectStruct(state.imageViewer.tsNumberOfFiles);
		state.imageViewer.objStructs(objCounter).axis1x=squeeze(oldIV.objectMajorAxisX(:, objCounter, :));
		state.imageViewer.objStructs(objCounter).axis1y=squeeze(oldIV.objectMajorAxisY(:, objCounter, :));
		state.imageViewer.objStructs(objCounter).axis2x=squeeze(oldIV.objectMinorAxisX(:, objCounter, :));
		state.imageViewer.objStructs(objCounter).axis2y=squeeze(oldIV.objectMinorAxisY(:, objCounter, :));
		state.imageViewer.objStructs(objCounter).coords=squeeze(oldIV.objectCenters(objCounter, :));		
		state.imageViewer.objStructs(objCounter).status=squeeze(oldIV.objectStatus(:, objCounter));		
	end
	
	if nargin<2
		ivSaveData
	else
		ivSaveData(outfile);
	end		
		
	
		