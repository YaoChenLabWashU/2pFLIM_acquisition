function FittingManySamples=FittingManySamples(times, flag)
%   This function fits many files. Times dictates how many files there are in total for analysis. The flag signals if tau1 and tau2 are
%   "fixed" or "free", and that dictates where in the matrix the output
%   will be written into.
global spc
chan=spc_mainChannelChoice;
% Section 1: Create a matrix with each column being 1)filenumber 2) p1, 3)empirical
% lifetime 4) chi2 for fixed parameters; 5) p1, 6) tau1, 7) tau2, 8)
% empirical lifetime, 9) chi2 for free-range parameters.
Results=zeros(times, 9);

% Section 2: Fit with parameters.
for counter=1:times
    formatSpec='FLIMsim%d.mat';
    NewName=sprintf(formatSpec,counter);
    load(NewName); % Load the file.
    spc.lifetimes{1,1}=n; % Input numbers into spc.lifetimes
    
    % Fit with double exponential and using empirically measured prf.
    spc_fitexp2prfGY(chan);
    Results(counter, 1)=counter;
    if ~isfield(spc.fits{chan},'failedFit') || spc.fits{chan}.failedFit || ...
            (isfield(spc.fits{chan},'redchisq') && spc.fits{chan}.redchisq > 1000)
        % bad news - FIT FAILED - don't rewrite the fit parameters
        Results(counter, 2)='failedFit';
    else
        % fit did not fail, so write the parameters
        % Now output values.
        if strcmp (flag, 'fixed')
            Results(counter, 2)=spc.fits{chan}.beta1/(spc.fits{chan}.beta1+spc.fits{chan}.beta3); %p1
            Results(counter, 3)=spc.fits{chan}.avgTauTrunc;%empirical lifetime; ; did not use spc_calcEmpiricalMean(chan) because the offset is not calculated every single time.
            Results(counter, 4)=spc.fits{chan}.redchisq; %chi2
        elseif strcmp (flag, 'free')
            Results(counter, 5)=spc.fits{chan}.beta1/(spc.fits{chan}.beta1+spc.fits{chan}.beta3); %p1
            Results(counter, 6)=spc.fits{chan}.beta2; %tau1
            Results(counter, 7)=spc.fits{chan}.beta4; %tau2
            Results(counter, 8)=spc.fits{chan}.avgTauTrunc % empirical lifetime; did not use spc_calcEmpiricalMean(chan) because the offset is not calculated every single time.
            Results(counter, 9)=spc.fits{chan}.redchisq; % chi2
            % Now getting the figure offset data.
            % get the lifetime data for the specified fit range
            [~,range] = spc_fitParamsFromGlobal(chan);
            t1 = (1:length([range(1):range(2)]));
            t1 = t1(:);
            lifetime = spc.lifetimes{chan}(range(1):range(2));
            lifetime = lifetime(:);
            
            a = sum(lifetime.*t1)/sum(lifetime)*spc.datainfo.psPerUnit/1000;
            
            % uses avgTau OR avgTauTrunc (determined in spc.switches)
            % gy 201111 should probably always use avgTauTrunc
            Results(counter, 10)=a - spc.fits{chan}.avgTauTrunc; % .average; figure offset data.
        end
    end
    
    % Section 6: Save the output file.
    save('FLIMSimulationResultsFree', 'Results');
    % Section 7: plot histograms for each of the parameters.
    
end
end
