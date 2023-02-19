% DarkCount was calculated with no laser light and sum(spc.lifetimes{k})
% See function PhotonCount.

function HalfwidthYC(DarkCount,range1, range2, nPeak)
global spc
global stats
nChan=numel(spc.lifetimes{1});
%disp('base  tot   fraction_afterpulse fraction_darkcount peak2/peak1');
data_ranges = [range1;range2];
if nPeak;
    p1 = nPeak;
    p2 = nPeak;
else
    p1 = 1;
    p2 = 2;
end

peaks = zeros(2, 1);
for k=p1:p2;
    this_range = spc.lifetimes{1}(data_ranges(k,1):data_ranges(k,2));
    numPts=240; %These are the number of non-zero photon counts.
    base=mean(spc.lifetimes{1}((end-60):(end-10)))-DarkCount/numPts;
    if base < 0
        base = 0;
    end
    baseline=mean(spc.lifetimes{1}((end-60):(end-10))); %minimum (including dark count and after pulse)
    tot=sum(spc.lifetimes{1})-numPts*base-DarkCount; 
    
    peak1=max(this_range)-base-DarkCount/numPts;
    Halfway=peak1/2+baseline; %50% peak for IRF
    
    if ~nPeak
        peaks(k) = peak1; 
    end
    
    indexpeak =find(spc.lifetimes{1} == max(this_range));
    i = indexpeak;
    while spc.lifetimes{1}(i)>= Halfway
        i = i-1;
    end 
    j = indexpeak;
    while spc.lifetimes{1}(j)>= Halfway
        j = j+1;
    end 
    
    index_start=i;
    index_end = j;
    
    index_start_real=(Halfway-spc.lifetimes{1}(index_start-1))/(spc.lifetimes{1}(index_start)-...
    spc.lifetimes{1}(index_start-1))+index_start-1;
    index_end_real=(Halfway-spc.lifetimes{1}(index_end-1))/(spc.lifetimes{1}(index_end)-...
    spc.lifetimes{1}(index_end-1))+index_end-1;
    time=(index_end_real-index_start_real)*12.5/256;
%     time = length(index) * 12.5/256; %pulse width in ns
    disp(['indexpeak_', num2str(k), ': ', num2str(indexpeak(1)*20/256)]);
    disp(['halfwidthIRF_', num2str(k),': ', num2str(time)]);
    halfwidths(k)=time;

end
disp('base  tot   fraction_afterpulse fraction_darkcount');
disp([num2str(base,'%5.1f') '  ' num2str(tot,'%8.0f') '  ' num2str(numPts*base/tot,'%8.5f') '  ' num2str(DarkCount/tot, '%8.5f')]);
stats(1)=base;
stats(2)=tot; 
stats(3)=numPts*base/tot;
stats(4)= halfwidths(1);
if nPeak == 1
    halfwidths(2) =  0;
end
stats(5)= halfwidths(2);
stats(6) = peaks(1)/peaks(2);

disp(['photon count: ',num2str(tot)] );


    