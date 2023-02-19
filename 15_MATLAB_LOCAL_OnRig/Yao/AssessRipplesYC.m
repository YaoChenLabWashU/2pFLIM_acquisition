function AssessRipplesYC
global spc
% First row displays Poisson noise (channel1 and channel 2)
% Second row displays stdev/mean as an assessment of magnitude of ripples
for k=1:1; 
    sum(spc.lifetimes{k})/5 % printing photon counts/s (5s in this case).
    gy(1,k)=1/sqrt(mean(spc.lifetimes{k}(50:200)));
    gy(2,k) =std(spc.lifetimes{k}(50:220))/mean(spc.lifetimes{k}(50:200)); 
    gy(3,k)=(gy(2,k)^2 - gy(1,k)^2)^0.5;
end; 
disp(gy);

end

