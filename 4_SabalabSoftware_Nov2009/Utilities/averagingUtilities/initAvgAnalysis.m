function initAvgAnalysis
	global gh state

	if exist('gh')
		if isfield(gh, 'avgAnalysis')
			if isfield(gh.avgAnalysis, 'figure1') & ishandle(gh.avgAnalysis.figure1)
				if ishandle(state.avgAnalysis.avgFigure)
					figure(state.avgAnalysis.avgFigure);
				end
				if ishandle(state.avgAnalysis.avgComponentFigure)
					figure(state.avgAnalysis.avgComponentFigure);
				end
				
				figure(gh.avgAnalysis.figure1);
				return
			end
		end
	end
	
	gh.avgAnalysis=guihandles(avgAnalysis);
	initGUIs('avgAnalysis.ini');
	