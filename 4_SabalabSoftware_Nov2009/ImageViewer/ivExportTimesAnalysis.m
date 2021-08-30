function ivExportTimesAnalysis(timePoints, prefix, clearMemory)
	global state
	
	if nargin<3
		clearMemory=0;
	end
	
	if nargin<2
		prefix='';
	end

	if nargin<1
		timePoints=state.imageViewer.tsFileCounter;
	end
	
	if isempty(timePoints)
		timePoints=1:state.imageViewer.tsNumberOfFiles;
	end
	
	disp('Creating waves...');
	waveList=ivTimeAnalysisToWaves(timePoints);
	
	disp('Exporting waves...');
	exportWave(waveList, prefix);
	
	if clearMemory
		disp('Killing waves...');
		kill(waveList, 'q');
	end