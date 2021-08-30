function abortPCells
	global state pcellFocusOutput pcellGrabOutput
	if state.pcell.pcellOn
		stop([pcellFocusOutput pcellGrabOutput]);
	end
	setPcellsToDefault;
