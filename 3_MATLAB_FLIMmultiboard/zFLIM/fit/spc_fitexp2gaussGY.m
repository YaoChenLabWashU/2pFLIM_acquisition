function betahat=spc_fitexp2gaussGY(chan)
% gy multiFLIM updated (start) 201111
global spc;

spc.fits{chan}.lastFitFunction = mfilename;
spc.fits{chan}.fitOrder=2;
[betaInit range floats]=spc_fitParamsFromGlobal(chan);
spc.fits{chan}.nFreeParams=sum([1 1 1 1 1 1].*floats);

% get the lifetime from the lifetimes structure
lifetime = spc.lifetimes{chan}(range(1):1:range(2));
x = [1:1:length(lifetime)];
spc.fit.lifetime=lifetime;

% if values are bad, get a good initial guess
beta0 = spc_initialValue_double(betaInit,lifetime,range,0);
     
% this is different from Ryohei's version
%  1) the fixed parameters are not searched at all, so the fit
%     should be more efficient.
%  2) there is an option of transforming the parameters (last parameter)
%     0 = no transform; 1 = log transform; 2 = sin transform (range 0-1)
%
% weights=sqrt(lifetime)/sqrt(max(lifetime));
spc.fit.failedFit=0; % initialize to not-failed
betahat = spc_nlinfitGY(x, lifetime, @exp2gaussGY, beta0, floats, [0 1 0 1 0 0]);
fit = exp2gaussGY(betahat, x);
if spc.fit.failedFit==0
    spc_betaIntoGlobal(betahat,chan,chan==spc_mainChannelChoice);  % update globals and display if current
    spc_fitPostCalcs(chan); % consider moving this into prev
    spc.fits{chan}.failedFit=0;
else
    spc.fits{chan}.failedFit=1;
end

t = [range(1):1:range(2)]*spc.datainfo.psPerUnit/1000;
spc_drawfit (t, fit, lifetime, betahat, chan);


function y = exp2gaussGY(par, x)
global spc;

pulseI=spc.datainfo.pulseInt / spc.datainfo.psPerUnit*1000;

% GY: first get the parameters in order:
ampl = par(1);
tau1 = par(2); 
amp2 = par(3);
tau2 = par(4); 
tau_d = par(5);
tau_g = par(6);

y1 = ampl*exp(tau_g^2/2/tau1^2 - (x-tau_d)/tau1);
y2 = erfc((tau_g^2-tau1*(x-tau_d))/(sqrt(2)*tau1*tau_g));
y=y1.*y2;

%"Pre" pulse
y1 = ampl*exp(tau_g^2/2/tau1^2 - (x-tau_d+pulseI)/tau1);
y2 = erfc((tau_g^2-tau1*(x-tau_d+pulseI))/(sqrt(2)*tau1*tau_g));

ya = y1.*y2+y;
ya = ya/2;

y1 = amp2*exp(tau_g^2/2/tau2^2 - (x-tau_d)/tau2);
y2 = erfc((tau_g^2-tau2*(x-tau_d))/(sqrt(2)*tau2*tau_g));
y=y1.*y2;

y1 = amp2*exp(tau_g^2/2/tau2^2 - (x-tau_d+pulseI)/tau2);
y2 = erfc((tau_g^2-tau2*(x-tau_d+pulseI))/(sqrt(2)*tau2*tau_g));

yb = y1.*y2+y;
yb = yb/2;

y=ya+yb;

% correct for BACKGROUND gy 20120718
y=spc_addBackgroundToFit(y);


