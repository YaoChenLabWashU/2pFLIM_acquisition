% DarkCount was calculated with no laser light and sum(spc.lifetimes{k})
% See function PhotonCount.

function afterPulseStatsYC(DarkCount)
global spc
nChan=numel(spc.lifetimes);
disp('base  tot   fraction_afterpulse fraction_darkcount peak2/peak1');
for k=1:1;
    numPts=numel(spc.lifetimes{k});
    base(k)=mean(spc.lifetimes{k}((end-80):(end-50)))-DarkCount(k)/numPts; 
    baseline(k)=mean(spc.lifetimes{k}((end-80):(end-50))); %minimum (including dark count and after pulse)
    tot(k)=sum(spc.lifetimes{k})-numPts*base(k)-DarkCount(k); 
    peak1=max(spc.lifetimes{k})-base(k)-DarkCount(k)/numPts;
    peak2=max(spc.lifetimes{k}(101:end-50))-base(k)-DarkCount(k)/numPts;
    
    Halfway=peak1/2+baseline(k); %50% peak for IRF
    
    indexpeak =find(spc.lifetimes{k} == max(spc.lifetimes{k}));
    index = find(spc.lifetimes{k} >= Halfway);
    index_start=index(1);
    index_end=index(length(index))+1;
    index_start_real=(Halfway-spc.lifetimes{k}(index_start-1))/(spc.lifetimes{k}(index_start)-...
    spc.lifetimes{k}(index_start-1))+index_start-1;
    index_end_real=(Halfway-spc.lifetimes{k}(index_end-1))/(spc.lifetimes{k}(index_end)-...
    spc.lifetimes{k}(index_end-1))+index_end-1;
    time=(index_end_real-index_start_real)*12.5/256;
   % time = length(index) * 12.5/256; %pulse width in ns
    disp(['indexpeak', num2str(indexpeak*12.5/256)]);
    disp(['halfwidthIRF', num2str(time)]);
    
    disp([num2str(base(k),'%5.1f') '  ' num2str(tot(k),'%8.0f') '  ' num2str(numPts*base(k)/tot(k),'%8.5f') '  ' num2str(DarkCount(k)/tot(k), '%8.5f')...
        '  ' num2str(peak2/peak1,'%8.5f')]);
    stats(k,1)=base(k);
    stats(k,2)=tot(k); 
    stats(k,3)=numPts*base(k)/tot(k);
    stats(k,4)=DarkCount(k)/tot(k);
    
    disp(['photon count: ',num2str(tot(k)/5)] );
end
    