function closePulseMaker

	global state gh
	try
		hideGUI('gh.pulseMaker.figure1');
		set(state.internal.pulsePatternPlot, 'Visible', 'off');
	catch
		disp('closePulseMaker: MATLAB must be closing.  Killing pulseMaker');
		delete(gh.pulseMaker.figure1);
		delete(state.internal.pulsePatternPlot);
	end