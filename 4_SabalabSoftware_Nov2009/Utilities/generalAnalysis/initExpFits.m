function initExpFits
	global state gh
	
	gh.expFitsGui=guihandles(expFitsGui);
	
	initGUIs('expFits.ini');
	
	if ~iswave('display_exp')
		wave('display_exp', []);
	end
	if ~iswave('display_expRange')
		wave('display_expRange', []);
	end
	if ~iswave('display_expFit')
		wave('display_expFit', []);
	end
	if ~iswave('expFit_amp')
		wave('expFit_amp', []);
	end
	if ~iswave('expFit_tau')
		wave('expFit_tau', []);
	end
	if ~iswave('expFit_tau2')
		wave('expFit_tau2', []);
	end
	
	plot({'display_exp', 'display_expFit'});
	state.expFits.figure=gcf;
	setPlotProps('display_expFit', 'color', 'red', 'linewidth', 2)	
	
	plot('expFit_tau')
	append('expFit_tau2', 'Axes', 0)
	append('expFit_amp', 'Axes', 0)
	setPlotProps('expFit_amp', 'marker', 'o')	
	setPlotProps('expFit_tau', 'marker', 'o')	
	setPlotProps('expFit_tau2', 'marker', 'o')	
	setPlotProps('expFit_tau2', 'color', 'red')	
	splayAxisVertical