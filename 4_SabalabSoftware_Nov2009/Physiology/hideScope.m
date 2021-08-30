function hideScope


	global state gh
	try
		set(gcbo, 'Visible', 'off');
		set(state.phys.internal.scopeHandle, 'Visible', 'off');
		hideGUI('gh.scope.figure1');
	catch
		disp('hideScope: MATLAB must be closing.  Killing scope');
		delete(gcbo);
	%	delete(state.phys.internal.scopeHandle);
	end