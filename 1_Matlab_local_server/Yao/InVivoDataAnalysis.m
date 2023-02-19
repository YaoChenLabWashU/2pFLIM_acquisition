function InVivoDataAnalysis=InVivoDataAnalysis(times, StepsPerCycle,psPerUnit,sPerStep,ADC,specStart,specEnd)
%   This function analyzes spcm files. Times dictates how many files there are in total for analysis. 
global spc; 
spc.datainfo.psPerUnit=psPerUnit;

New = importdata('mouse3_618SKFfirst_Data.mat');

chan=spc_mainChannelChoice;
% Section 1: Create a matrix with each column being 1)step number (with al the cycles bundled together) 2) p1, 3)empirical
% lifetime 4) chi2 ; 5) fitted lifetime, all with fixed parameters.
Results=zeros(times*StepsPerCycle, 5);

% Section 2: Fit with parameters. 
for step=1:times*StepsPerCycle
    spc.lifetimes{1,1}=zeros(1,ADC);
    for spectral=specStart:specEnd
    spc.lifetimes{1,1}=spc.lifetimes{1,1}+New.data(step,ADC*(spectral-1)+1:ADC*spectral); % peak spectral channel data
    end
    % Fit with double exponential and using empirically Gaussian Fit.
    spc_fitexp2gaussGY(chan);
    spc_adjustTauOffset(1); % update TauOffset
    Results(step, 1)=(step-1)*sPerStep;
    if ~isfield(spc.fits{chan},'failedFit') || spc.fits{chan}.failedFit || ...
            (isfield(spc.fits{chan},'redchisq') && spc.fits{chan}.redchisq > 1000)
        % bad news - FIT FAILED - don't rewrite the fit parameters
        Results(step, 2)='failedFit';
    else
        % fit did not fail, so write the parameters
        % Now output values.
            Results(step, 2)=spc.fits{chan}.beta1/(spc.fits{chan}.beta1+spc.fits{chan}.beta3); %p1
            Results(step, 3)=spc.fits{chan}.avgTauTrunc;%empirical lifetime; ; did not use spc_calcEmpiricalMean(chan) because the offset is not calculated every single time.
            Results(step, 4)=spc.fits{chan}.redchisq; %chi2
            Results(step, 5)=spc.fits{chan}.avgTau; % mean Tau calculated from fit
        
    end
end
    
    % Section 6: Save the output file.
    Results(:,6)=Results(:,1)/60; % Convert time course from second to minute
    save('mouse3_730_SKFFirst_AnalysisChannel6To13_OffsetAdjusted', 'Results');

    % Section 7: plot histograms for each of the parameters.
    figure; %Create a figure.
    plot(Results(:,6),Results(:,5)) % Plot fitted lifetime over time.
    xlabel('Time (min)');
    ylabel('Fitted lifetime (ns)');
end

% Can make load file, and output filename input
% parameters. Look at histograms and analysis results with multiple spectral channels. Are the lifetimes
% betwen mouse 1 and mouse 2 truly different? Save figure automatically;
% save with parameters and title.
