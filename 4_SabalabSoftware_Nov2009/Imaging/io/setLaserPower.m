function setLaserPower(laser, power)

	global state
	state.pcell.(['pcellScanning' num2str(laser)])=power;
	updateGUIByGlobal(['state.pcell.pcellScanning' num2str(laser)]);
	state.internal.needNewPcellPowerOutput=1;
	applyChangesToOutput;