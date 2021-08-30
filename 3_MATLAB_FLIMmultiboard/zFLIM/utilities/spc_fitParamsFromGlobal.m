function [beta0 range floats]=spc_fitParamsFromGlobal(chan)
% returns [beta0 range floats] based on spc.fits{chan}
global spc
nsPerPoint=spc.datainfo.psPerUnit/1000;

beta0(1)=spc.fits{chan}.beta1;
beta0(2)=spc.fits{chan}.beta2/nsPerPoint;
beta0(3)=spc.fits{chan}.beta3;
beta0(4)=spc.fits{chan}.beta4/nsPerPoint;
beta0(5)=spc.fits{chan}.beta5/nsPerPoint;
if findstr('prf',spc.fits{chan}.lastFitFunction)
    beta0(6)=spc.fits{chan}.beta6;  % beta6 is scatter (population)
else
    beta0(6)=spc.fits{chan}.beta6/nsPerPoint;  % beta6 is gauss width
end

nsRange=[spc.fits{chan}.fitstart spc.fits{chan}.fitend];
range=round(nsRange/nsPerPoint);

% floats is logical, indicating those parameters NOT fixed
% [pop1(always) tau1 pop2(always) tau2 deltaT0 gaussWidth]
floats = ~[0 spc.fits{chan}.fixtau1 0 spc.fits{chan}.fixtau2 spc.fits{chan}.fix_delta spc.fits{chan}.fix_g];
    