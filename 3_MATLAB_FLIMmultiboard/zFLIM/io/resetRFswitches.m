function resetRFswitches
global RFswitchOutput state
% if the RFswitches are being used, reset them to the default state
if ~isempty(RFswitchOutput)
    putvalue(RFswitchOutput, state.spc.init.RFswitchesOffState);
end