function spc_translateFitToFits(chan)
% multiFLIM: translates from spc.fit (in points units) to spc.fits{chan} (in ns units) 
global spc
nsPerPoint=spc.datainfo.psPerUnit/1000;

% scaled beta0 for display values
sbeta0=spc.fit.beta0;
sbeta0([2 4 5 6])=spc.fit.beta0([2 4 5 6])*nsPerPoint;
for k=1:6
    spc.fits{chan}.(['beta' num2str(k)])=sbeta0(k);
end
nsRange=spc.fit.range*nsPerPoint;
spc.fits{chan}.fitstart=nsRange(1);
spc.fits{chan}.fitend=nsRange(2);
spc.fits{chan}.range=spc.fit.range; %TODO temporary!

% Calculate and display population fractions
	tau=sbeta0(2);
    tau2=sbeta0(4);
    pop1 = sbeta0(1)/(sbeta0(3)+sbeta0(1));
	pop2 = sbeta0(3)/(sbeta0(3)+sbeta0(1));
    spc.fits{chan}.pop1=pop1;
    spc.fits{chan}.pop2=pop2;
%   set(handles.pop1, 'String', num2str(pop1,3));
% 	set(handles.pop2, 'String', num2str(pop2,3));
% Calculate and display mean tau from fit
    mean_tau = (tau*tau*pop1+tau2*tau2*pop2)/(tau*pop1 + tau2*pop2);
	spc.fit.avgTau=mean_tau;  % save this value
    spc.fits{chan}.avgTau=mean_tau;
    
% Now estimate the truncation of the distribution between the 
%  peak of the lifetime distribution and the end
% Added by gy 20110307 for better estimation of Figure Offset
%  see modifications also to spc_adjustTauOffset
    tmax=(spc.fit.range(2)-spc.fit.range(1)-spc.fit.beta0(5))*spc.datainfo.psPerUnit/1000;
    % disp(['tmax =' num2str(tmax,3)]);  % for debugging
    % following formula from the definite integral from 0 to tmax
    %  of pop1*t*exp(-t/tau1) + pop1*t*exp(-t/tau2)
    % over the definite integral from 0 to tmax
    %  of pop1*exp(-t/tau1) + pop2*exp(-t/tau2)
    ff1=exp(-tmax/tau);
    ff2=exp(-tmax/tau2);
    spc.fit.avgTauTrunc = ...
       (pop1*(tau^2-(tau*(tau+tmax))*ff1) + pop2*(tau2^2-(tau2*(tau2+tmax))*ff2)) ...
        / (pop1*tau*(1-ff1) + pop2*tau2*(1-ff2));
    spc.fits{chan}.avgTauTrunc = spc.fit.avgTauTrunc;

% gy 20110307 - following lines choose between 
%   average Tau (integrated 0 to inf) or avgTauTrunc
    spc.switches.truncateIntegral = 1;
    if spc.switches.truncateIntegral
        spc.fits{chan}.average = spc.fit.avgTauTrunc;
    else
        spc.fits{chan}.average = spc.fit.avgTau;
    end
  
% and copy other parameters (including newly generated ones)
copyParams={'fixtau1' 'fixtau2' 'fix_delta' 'fix_g' ...
    'chisq' 'redchisq' 'curve' 'residual' 'secOffset' 'tauEmpirical'};
for k=1:numel(copyParams)
    pName=copyParams{k};
    if isfield('spc.fit',pName)
        spc.fits{chan}.(pName)=spc.fit.pName;
    end
end
    
    
