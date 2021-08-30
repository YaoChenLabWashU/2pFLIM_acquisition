function betahat=spc_fitexp2prfGY(chan)
% gy multiFLIM updated (start) 201111
global spc;

spc.fits{chan}.lastFitFunction = mfilename;
spc.fits{chan}.fitOrder=2;
[betaInit range floats]=spc_fitParamsFromGlobal(chan);
spc.fits{chan}.nFreeParams=sum([1 1 1 1 1 1].*floats);


% get the lifetime from the lifetimes structure
lifetime = spc.lifetimes{chan}(range(1):1:range(2));
x = [1:1:length(lifetime)];  % x starts at 1?? gy

% if values are bad, get a good initial guess
beta0 = spc_initialValue_double(betaInit,lifetime,range,1);
% pass range and prf for the current channel through spc.fit
spc.fit.range = range;
spc.fit.prf = spc.fits{chan}.prf;
spc.fit.lifetime=lifetime;
   
% this is different from Ryohei's version
%  1) the fixed parameters are not searched at all, so the fit
%     should be more efficient.
%  2) there is an option of transforming the parameters (last parameter)
%     0 = no transform; 1 = log transform; 2 = sin transform (range 0-1)
%
% weights=sqrt(lifetime)/sqrt(max(lifetime));

% modified gy 20121218 WEIGHTS NO LONGER USED IN spc_nlinfitGY
% weights=lifetime; weights(weights==0)=1;
% weights=sqrt(max(weights))./sqrt(weights);

spc.fit.failedFit=0; % initialize to not-failed
% for the scatter parameter (6), use a 3-transform (sinusoid 0-10000)
betahat = spc_nlinfitGY(x, lifetime, @spc_exp2prfGY, beta0, floats, [0 1 0 1 0 3]);
fit = spc_exp2prfGY(betahat, x);
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

t = [range(1):range(2)]*spc.datainfo.psPerUnit/1000;
spc_drawfit (t, fit, lifetime, betahat, chan);
