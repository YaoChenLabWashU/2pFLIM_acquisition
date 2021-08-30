% DarkCount was calculated with no laser light and sum(spc.lifetimes{1})
function afterPulseStats(DarkCount)
global spc
nChan=numel(spc.lifetimes);
disp('base  tot   fraction_afterpulse fraction_darkcount');
for k=1:nChan; 
    numPts=numel(spc.lifetimes{k});
    base(k)=mean(spc.lifetimes{k}((end-80):(end-50)))-DarkCount/numPts;  
    tot(k)=sum(spc.lifetimes{k})-numPts*base(k)-DarkCount; 
    disp([num2str(base(k),'%5.1f') '  ' num2str(tot(k),'%8.0f') '  ' num2str(numPts*base(k)/tot(k),'%8.5f') '  ' num2str(DarkCount/tot(k), '%8.5f')]);
    stats(k,1)=base(k);
    stats(k,2)=tot(k); 
    stats(k,3)=numPts*base(k)/tot(k);
    stats(k,4)=DarkCount/tot(k);
end
    