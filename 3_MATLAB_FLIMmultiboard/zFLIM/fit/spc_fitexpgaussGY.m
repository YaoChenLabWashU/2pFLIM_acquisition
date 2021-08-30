function betahat=spc_fitexpgaussGY(chan)
% GY: fit single exponential + gaussian
% modified from Ryohei's code to reduce dimensionality of fit when
% parameters are fixed
global spc;

spc.fits{chan}.lastFitFunction = mfilename;
spc.fits{chan}.fitOrder=2;
[betaInit range floats]=spc_fitParamsFromGlobal(chan);
beta0=betaInit;
spc.fits{chan}.nFreeParams=sum([1 1 0 0 1 1].*floats);

nsPerPoint=spc.datainfo.psPerUnit/1000;
% get the lifetime from the lifetimes structure
lifetime = spc.lifetimes{chan}(range(1):range(2));
x = 1:length(lifetime);
spc.fit.lifetime=lifetime;

if beta0(1) <= 100 || beta0(2) <= 0.5*1000/spc.datainfo.psPerUnit || beta0(2) >=5*1000/spc.datainfo.psPerUnit
    beta0(1) = max(spc.lifetimes{chan}(range(1):range(2)));
    beta0(2) = sum(spc.lifetimes{chan}(range(1):range(2)))/beta0(1);
end
beta0(3) = 0;
%beta0(4) = 1;
if beta0(5) <= -1/nsPerPoint || beta0(5) >= 5/nsPerPoint; 
    beta0(5) = 1/nsPerPoint;
end
if beta0(6) <= 0.05/nsPerPoint || beta0(6) >= 1.0/nsPerPoint 
    beta0(6) = 0.15/nsPerPoint;
end

% GY: set parameter fix status and transform

floats = floats & [1 1 0 0 1 1]; % fix amp2 tau2 ~[0 fix1 1 1 fix_d fix_g];
transform = []; %[0 1 0 0 0 0];  % log for tau1

spc.fit.failedFit=0; % initialize to not-failed
betahat = spc_nlinfitGY(x, lifetime, @expgaussGY, beta0, floats, transform);
if spc.fit.failedFit==0
    spc_betaIntoGlobal(betahat,chan,chan==spc_mainChannelChoice);  % update globals and display if current
    spc_fitPostCalcs(chan); % consider moving this into prev
    spc.fits{chan}.failedFit=0;
else
    spc.fits{chan}.failedFit=1;
end
%Drawing

fit = expgauss(betahat, x);
t = [range(1):range(2)]*nsPerPoint;

spc_drawfit (t, fit, lifetime, betahat, chan);


function y = expgaussGY(beta0, x)
%beta0(1): peak
%beta0(2): exp tau
%beta0(5): center
%beta0(6): gaussian width
% 1/2*erfc[(s^2-tau*x)/{sqrt(2)*s*tau}] * exp[s^2/2/tau^2 - x/tau]

global spc;

pulseI=spc.datainfo.pulseInt / spc.datainfo.psPerUnit*1000;

tau1 = beta0(2);
tau_g = beta0(6);
tau_d = beta0(5);

y1 = beta0(1)*exp(tau_g^2/2/tau1^2 - (x-tau_d)/tau1);
y2 = erfc((tau_g^2-tau1*(x-tau_d))/(sqrt(2)*tau1*tau_g));
y=y1.*y2;

%"Pre" pulse
y1 = beta0(1)*exp(tau_g^2/2/tau1^2 - (x-tau_d+pulseI)/tau1);
y2 = erfc((tau_g^2-tau1*(x-tau_d+pulseI))/(sqrt(2)*tau1*tau_g));

y = y1.*y2+y ;
y=y/2;

% correct for BACKGROUND gy 20120718
y=spc_addBackgroundToFit(y);
