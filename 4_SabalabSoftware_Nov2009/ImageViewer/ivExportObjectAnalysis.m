function ivExportObjectAnalysis(objects, prefix, clearMemory)
% function ivExportObjectAnalysis(objects, prefix, clearMemory)	
	global state
	
	if nargin<3
		clearMemory=0;
	end
	
	if nargin<2
		prefix='';
	end
	
	if nargin<1
		objects=state.imageViewer.currentObject;
	end

	if isempty(objects)
		objects=1:size(state.imageViewer.objStructs,2);
	end
	
	disp('Creating waves...');
	waveList=ivObjectAnalysisToWaves(objects, 0);
	
	disp('Exporting waves...');
	exportWave(waveList, prefix);
	
	if clearMemory
		disp('Killing waves...');
		kill(waveList, 'q');
	end