function adjustLaserScanTable(power)
global laserScanTable powerTable
for k=1:size(laserScanTable,1)
    col=find(powerTable(1,:)==laserScanTable(k,1));
    [minVal locMin]=min(powerTable(2:end,col));
    nomPower=interp1(powerTable((locMin+1):end,col)+rand(size(powerTable,1)-locMin,1)/1000,powerTable((locMin+1):end,1),power);
    laserScanTable(k,2)=nomPower;
end