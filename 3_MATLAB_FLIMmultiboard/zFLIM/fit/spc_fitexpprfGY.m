function betahat=spc_fitexpprfGY(chan)
% GY: fit single exponential + gaussian
% modified from Ryohei's code to reduce dimensionality of fit when
% parameters are fixed
global spc;

spc.fits{chan}.lastFitFunction = mfilename;
spc.fits{chan}.fitOrder=2;
[betaInit range floats]=spc_fitParamsFromGlobal(chan);
spc.fits{chan}.nFreeParams=sum([1 1 0 0 1 1].*floats);
beta0=betaInit;

nsPerPoint=spc.datainfo.psPerUnit/1000;
% get the lifetime from the lifetimes structure
lifetime = spc.lifetimes{chan}(range(1):range(2));
x = 1:length(lifetime);

if beta0(1) <= 100 || beta0(2) <= 0.5*1000/spc.datainfo.psPerUnit || beta0(2) >=5*1000/spc.datainfo.psPerUnit
    beta0(1) = max(spc.lifetimes{chan}(range(1):range(2)));
    beta0(2) = sum(spc.lifetimes{chan}(range(1):range(2)))/beta0(1);
end
beta0(3) = 0;
beta0(4) = 1;
if beta0(5) <= -1/nsPerPoint || beta0(5) >= 5/nsPerPoint; 
    beta0(5) = 1/nsPerPoint;
end
% if beta0(6) <= 0.05/nsPerPoint || beta0(6) >= 1.0/nsPerPoint 
%     beta0(6) = 0.15/nsPerPoint;
% end

% GY: set parameter fix status and transform
floats = floats & [1 1 0 0 1 1]; % fix amp2 tau2 [[[and gauss]]] not scatter gy 20120720
transform = [0 0 0 0 0 3]; %[0 1 0 0 0 0]; %[0 1 0 0 0 0];  % log for tau1
% pass range and prf for the current channel through spc.fit
spc.fit.range = range;
spc.fit.prf = spc.fits{chan}.prf;
spc.fit.lifetime=lifetime;

spc.fit.failedFit=0; % initialize to not-failed
betahat = spc_nlinfitGY(x, lifetime, @spc_expprfGY, beta0, floats, transform);
fit = spc_expprfGY(betahat, x);

if spc.fit.failedFit==0
    % calculate the fraction of photons from SHG/scatter term
    betahat2=betahat;  betahat2(6)=0; fit2 = spc_exp2prfGY(betahat2,x);
    spc.fits{chan}.frSHG = 1-(sum(fit2)/sum(fit));
    disp(['fraction of photons from SHG: ' num2str(spc.fits{chan}.frSHG)]);
    
    spc_betaIntoGlobal(betahat,chan,chan==spc_mainChannelChoice);  % update globals and display if current
    spc_fitPostCalcs(chan); % consider moving this into prev
    spc.fits{chan}.failedFit=0;
else
    spc.fits{chan}.failedFit=1;
end
%Drawing

t = (range(1):range(2))*nsPerPoint;
spc_drawfit (t, fit, lifetime, betahat, chan);

