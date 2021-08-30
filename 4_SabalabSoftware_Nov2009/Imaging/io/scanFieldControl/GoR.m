function gr=GoR

	global imageData
m=mean2(imageData{1});
m0=0;
eval(['m0=state.acq.binFactor*state.acq.pmtOffsetChannel' num2str(1) ';']);
g=m-m0;

m=mean2(imageData{2});
m0=0;
eval(['m0=state.acq.binFactor*state.acq.pmtOffsetChannel' num2str(2) ';']);
r=m-m0;

gr=g/r;

