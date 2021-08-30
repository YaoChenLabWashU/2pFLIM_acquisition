function gddScan(gdd)
% into the CYCLE DEFINITION 'function' box, type
%     gddScan(gddVal);  gddVal=gddVal+gddIncr; 
% make sure these are defined in the base workspace.
% these values will be exported to Excel (assuming it's linked)
global state
doLaserCmd(['GDD=' num2str(gdd)]);
state.laser.gdd=gdd;
state.laser.configGlobals.gdd=2;  % mark for storage in header
updateHeaderString('state.laser.gdd');
r=['r' num2str(25 + state.files.lastAcquisition+1)];  % because we're setting it for the next acquisition
try 
    ddepoke(state.internal.excelChannel, [r 'c63:' r 'c64'], [state.laser.wavelength state.laser.gdd]);
end
    