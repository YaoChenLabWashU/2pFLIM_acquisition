function yPlusBkg=spc_addBackgroundToFit(fit)
% adds a constant offset to lifetime fits to bring prepulse level to
% the observed level in the data
global spc
% the minimum point in the fit defines the end of the prepulse
[~,locmin]=min(fit);
% calculate the offset needed to bring this region up to the observed
% value in the data (which are stored in spc.fit.lifetime)
backCorr=(sum(spc.fit.lifetime(1:locmin))-sum(fit(1:locmin)))/locmin;
yPlusBkg=fit+max(backCorr,0);
spc.fit.backCorr=max(backCorr,0);  % save it (needs to be copied back for each channel)
