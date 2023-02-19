function YaoImagingPower(Power)
% Defines Imaging Laser Power

global state;
% make the variable state accessible in this function.

state.pcell.pcellScanning1 = Power;
updateGUIByGlobal('state.pcell.pcellScanning1');
% Below was copied from Gary's cyclelaser
state.internal.needNewPcellPowerOutput=1;
try
	applyChangesToOutput;
catch lastErrCode
	disp(['error in apply pcell change : ' lastErrCode]);
end;  %added gy 20111031

