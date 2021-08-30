function hideScope

	try
		global state
		set(gcf, 'Visible', 'off');
	catch
		disp('hideScope: MATLAB must be closing.  Killing scope');
		delete(gcf);
	end