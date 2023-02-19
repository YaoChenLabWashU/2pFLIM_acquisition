% DarkCount was calculated with no laser light and sum(spc.lifetimes{k})
% See function PhotonCount.

function afterPulseStatsYC_save(DarkCount, CFD, PMT_Gain)
global spc
global data;
global index;

nChan=numel(spc.lifetimes);
disp('base  tot   fraction_afterpulse fraction_darkcount peak2/peak1');
for k=1:1;
    numPts=numel(spc.lifetimes{k});
    base(k)=mean(spc.lifetimes{k}((end-80):(end-50)))-DarkCount(k)/numPts;  
    tot(k)=sum(spc.lifetimes{k})-numPts*base(k)-DarkCount(k); 
    peak1=max(spc.lifetimes{k})-base(k)-DarkCount(k)/numPts;
    peak2=max(spc.lifetimes{k}(101:end-50))-base(k)-DarkCount(k)/numPts;
    disp([num2str(base(k),'%5.1f') '  ' num2str(tot(k),'%8.0f') '  ' num2str(numPts*base(k)/tot(k),'%8.5f') '  ' num2str(DarkCount(k)/tot(k), '%8.5f')...
        '  ' num2str(peak2/peak1,'%8.5f')]);
    stats(k,1)=base(k);
    stats(k,2)=tot(k); 
    stats(k,3)=numPts*base(k)/tot(k);
    stats(k,4)=DarkCount(k)/tot(k);
    
    peak_ratio=peak2/peak1;
    
    %file='C:\Users\neuro_micro\Desktop\Yao\FLP_20160203\CFD_adjust';
    %save(file,CFD,PMT_Gain,stats(k,2),stats(k,3),peak_ratio);
    index=index+1;
    data(index,1)=CFD;
    data(index,2)=PMT_Gain;
    data(index,3)=stats(k,2);
    data(index,4)=stats(k,3);
    data(index,5)=peak_ratio;
end
    