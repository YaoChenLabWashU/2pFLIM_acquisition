function initializeRFswitches
% sets up the digital output that controls the RF switches
% and initialize them to value of state.spc.init.RFswitches.default
% which should be the imaging, non-FLIM state

global state RFswitchOutput
evalin('base','global RFswitchOutput');

if state.spc.init.RFswitchesInUse
    % create the digital output device
    RFswitchOutput=digitalio('nidaq',state.spc.init.RFswitchesBoardIndex);
    addline(RFswitchOutput,0:3,'out'); % set up as output
    putvalue(RFswitchOutput,state.spc.init.RFswitchesOffState); % initialize all
else
    RFswitchOutput=[];
end


