function loadCycle(pname, fname)
	global state

	if nargin<2
		if ~isempty(state.analysis.setupPath)
			try
				cd(state.analysis.setupPath);
			catch
			end
		end
		[fname, pname]=uigetfile('*.ana', 'Choose analysis setup');
	end

	if ~isnumeric(fname) & ~isempty(fname)
		analysis=load(fullfile(pname, fname), '-MAT');

		fnames=fieldnames(analysis.analysis);
		for counter=1:length(fnames)
			eval(['state.analysis.' fnames{counter} ' = analysis.analysis.' fnames{counter} ';']);
			updateGUIByGlobal(	['state.analysis.' fnames{counter}])
		end
		
		state.analysis.setupName = fname;
		state.analysis.setupPath = pname;
		state.analysis.displayLine=1;
		updateLineDisplay;
% 		makeAnalysisMenu;
% 		checkCurrentAnalysis;		
		
		setStatusString('analysis setup loaded');
	else
		setStatusString('Cannot load setup');
	end
	
	