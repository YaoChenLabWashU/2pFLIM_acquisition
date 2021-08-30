function hideCurrentWindow
	try
		set(gcf, 'Visible', 'off');
	catch
		disp('hideScope: MATLAB must be closing.  Killing window');
		delete(gcf);
	end