% DarkCount was calculated with no laser light and sum(spc.lifetimes{k})
% See function PhotonCount.

function afterPulseStatsYC(DarkCount)
global spc stats
nChan=numel(spc.lifetimes);
disp('base  tot   fraction_afterpulse fraction_darkcount peak2/peak1');
for k=1:1;
    numPts=numel(spc.lifetimes{k});
    base(k)=mean(spc.lifetimes{k}((end-58):(end-41)))-DarkCount(k)/numPts;  
    tot(k)=sum(spc.lifetimes{k})-numPts*base(k)-DarkCount(k); 
    peak1=max(spc.lifetimes{k}(32:56))-base(k)-DarkCount(k)/numPts;
    peak2=max(spc.lifetimes{k}(81:112))-base(k)-DarkCount(k)/numPts;
    disp([num2str(base(k),'%5.1f') '  ' num2str(tot(k),'%8.0f') '  ' num2str(numPts*base(k)/tot(k),'%8.5f') '  ' num2str(DarkCount(k)/tot(k), '%8.5f')...
        '  ' num2str(peak2/peak1,'%8.5f')]);
    stats(k,1)=base(k);
    stats(k,2)=tot(k); 
    stats(k,3)=numPts*base(k)/tot(k);
    stats(k,4)=DarkCount(k)/tot(k);
end
    