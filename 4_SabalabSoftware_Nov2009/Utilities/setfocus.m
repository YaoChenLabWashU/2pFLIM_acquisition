function setfocus(gui)
	if ishandle(gui)
		uicontrol(gui)

	else
		disp('unknown gui');
	end