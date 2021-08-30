function closeNotebook
	try
		global state
		set(gcf, 'Visible', 'off');
	catch
		disp('closeBook: MATLAB must be closing.  Killing notebooks');
		delete(gcf);
	end