function power=gyPcellScan(wavelns,pcellSettings)
% example:  powerTable=gyPcellScan(800:10:900, 0:5:90)
global aoGY power
if isempty(aoGY)
    aoGY=analogoutput('nidaq','Dev3');
    addchannel(aoGY,0);
end
for k=1:length(wavelns)
    tuneLaser(wavelns(k));
    for j=1:length(pcellSettings)
        % set the pcell voltage
        putsample(aoGY,powerToPcellVoltage(pcellSettings(j),1));
        power(j,k)=gyPowerTest;
    end
end
% add in row and column titles
power=vertcat(wavelns(:)',power);
power=horzcat([0; pcellSettings(:)],power);


