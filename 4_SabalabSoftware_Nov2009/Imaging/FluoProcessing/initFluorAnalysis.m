function initFluorAnalysis
	global gh state
	
	if exist('state')
		if ~isfield(state, 'headerString')
			state.headerString='';
		end
	else
		state.headerString='';
	end

	gh.fluorAnalysisSettings=guihandles(fluorAnalysisSettings);
	openini('fluorAnalysis.ini');
	
	