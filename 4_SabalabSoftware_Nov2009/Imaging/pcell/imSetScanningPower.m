function imSetScanningPower(power, pcellNumber)
	if nargin<2
		pcellNumber=1;
	end
	
	global state
	
	fieldName=['pcellScanning' num2str(pcellNumber)];
	state.pcell.(fieldName)=power;
	updateGUIByGlobal(['state.pcell.' fieldName]);
	state.internal.needNewPcellPowerOutput=1;
	applyChangesToOutput;