% PRF convert from 256 to 64 script
% load the PRF into channel 1, then...
prf1=spc.fits{1}.prf;
for k=1:64; prf1s(k)=mean(prf1((k*4-3):(k*4))); end
prf1s=prf1s/(sum(prf1s));
clf;figure(22); plot(1:256,prf1,'.k'); hold on; plot(1:4:256,prf1s/4,'or');
prf=prf1s; 
% type something like: save('prfTop64_20121127','prf');