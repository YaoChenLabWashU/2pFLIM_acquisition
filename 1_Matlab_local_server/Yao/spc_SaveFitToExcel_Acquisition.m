function spc_SaveFitToExcel
global spc state gui
% first make sure that we have an Excel file open and attached
if ~isfield(spc,'analysis') || ~isfield(spc.analysis,'excelChannel') ...
        || isempty(spc.analysis.excelChannel)
    return
end

opt=spc.analysis.excelExportOptions; % get the options list

% write a line to the excel channel
% parameter titles are specified in spc_OpenExcelFile
%
% FILENAME
rng=spc_WriteToExcelCOM(0,0,spc.filename);
rng.HorizontalAlignment=4;  % right aligned

% TIME of acquisition
try
    spc_WriteToExcelCOM(0,0,spc.datainfo.time);
catch
    spc_WriteToExcelCOM(0,0,0);
end

% extract FILE NUMBER from spc.filename
[~, name, ext] = fileparts(spc.filename);
filenum = str2double(name(end-2:end));
spc_WriteToExcelCOM(0,0,filenum); % file number

% laser WAVELENGTH and POWER
try
    spc_WriteToExcelCOM(0,0,spc.datainfo.laser.wavelength);
catch
    spc_WriteToExcelCOM(0,0,'');
end
try
    spc_WriteToExcelCOM(0,0,spc.datainfo.laser.power);
catch
    spc_WriteToExcelCOM(0,0,'');
end

% six ROI columns of std imaging channel 1, then six of channel two
% for gyROIs; blank if value doesn't exist
if opt.ROIvals
    for stdChan=1:2
        for roi=1:opt.maxROIs
            if all([roi stdChan] <= size(gui.gy.ROIvals))
                rng=spc_WriteToExcelCOM(0,0,gui.gy.ROIvals(roi,stdChan)); rng.NumberFormat='0';
            else
                spc_WriteToExcelCOM(0,0,'');
            end
        end
    end
end
% multiFLIM - save a set of fit values for EACH flimChannel
%   empirical mean lifetime for rectangular ROI
%   gyROIx6: Lifetime
%   gyROIx6: Mean intensity
%   gyROIx6: Count
%   figOffset
%   fitstart
%   fitend
%   fit(if successful):  
%      type, order, redChiSq, a1, t1, a2, t2, delX, gauss, pop1, pop2, avgTau, avgTauTrunc
FLIMchannels=find(bitget(state.spc.FLIMchoices,1));
for fc=FLIMchannels
    % EMPIRICAL MEAN TAU (for the rectangular lifetime ROI)
    rng=spc_WriteToExcelCOM(0,0,spc_calcEmpiricalMean(fc)); rng.NumberFormat='0.00';
    
    % ROIS: Lifetime
    nROIs=size(gui.gy.ROIlife,1);
    if opt.ROIlife
        for roi=1:opt.maxROIs
            if roi<=nROIs
                rng=spc_WriteToExcelCOM(0,0,gui.gy.ROIlife(roi,fc)); rng.NumberFormat='0.00';
            else
                spc_WriteToExcelCOM(0,0,'');
            end
        end
    end
    % ROIS: Mean intensity (count/nPixels)
    if opt.ROImean
        for roi=1:opt.maxROIs
            if roi<=nROIs
                rng=spc_WriteToExcelCOM(0,0,gui.gy.ROImean(roi,fc)); rng.NumberFormat='0.0';
            else
                spc_WriteToExcelCOM(0,0,'');
            end
        end
    end
    % ROIS: Total photon count in ROI
    if opt.ROIcount
        for roi=1:opt.maxROIs
            if roi<=nROIs
                rng=spc_WriteToExcelCOM(0,0,gui.gy.ROIcount(roi,fc)); rng.NumberFormat='0';
            else
                spc_WriteToExcelCOM(0,0,'');
            end
        end
    end
    
    % FIG OFFSET
    rng=spc_WriteToExcelCOM(0,0,spc.switchess{fc}.figOffset); rng.NumberFormat='0.00';
    % FIT Range (Start, End)
    rng=spc_WriteToExcelCOM(0,0,spc.fits{fc}.fitstart); rng.NumberFormat='0.0';
    rng=spc_WriteToExcelCOM(0,0,spc.fits{fc}.fitend); rng.NumberFormat='0.0';
    
    
    % now the fit parameters, if the fit worked
    if opt.fitDetails
    if ~isfield(spc.fits{fc},'failedFit') || spc.fits{fc}.failedFit || ...
            (isfield(spc.fits{fc},'redchisq') && spc.fits{fc}.redchisq > 1000)
        % bad news - FIT FAILED - don't rewrite the fit parameters
        spc_WriteToExcelCOM(0,0,'failedFit');
        for k=1:12 %skip 13 columns
            spc_WriteToExcelCOM(0,0,'');
        end
    else % fit did not fail, so write the parameters
        % FIT TYPE
        if findstr('gauss',spc.fits{fc}.lastFitFunction)
            type='gauss';
        elseif findstr('prf',spc.fits{fc}.lastFitFunction)
            type='prf';
        elseif findstr('triple',spc.fits{fc}.lastFitFunction)
            type='triple';
        else
            type='unknown';
        end
        spc_WriteToExcelCOM(0,0,type);
        
        % FIT ORDER (1)
        spc_WriteToExcelCOM(0,0,spc.fits{fc}.fitOrder);
        % REDUCED CHISQ (2)
        rng=spc_WriteToExcelCOM(0,0,spc.fits{fc}.redchisq); rng.NumberFormat='0.00';
        % AMP1 (3)
        rng=spc_WriteToExcelCOM(0,0,spc.fits{fc}.beta1); rng.NumberFormat='0';
        
        % TAU1 (4)
        tau1=spc.fits{fc}.beta2;
        rng=spc_WriteToExcelCOM(0,0,tau1); rng.NumberFormat='0.00';
        % (italicize if fixed)
        if spc.fits{fc}.fixtau1
            rng.Font.Italic=1;
        end
        
        % AMP2 (5)
        rng=spc_WriteToExcelCOM(0,0,spc.fits{fc}.beta3);
        rng.NumberFormat='0';
        
        % TAU2 (6)
        tau2=spc.fits{fc}.beta4;
        rng=spc_WriteToExcelCOM(0,0,tau2); rng.NumberFormat='0.00';
        if spc.fits{fc}.fixtau2
            rng.Font.Italic=1;
        end
        
        % DELTA T (7)
        rng=spc_WriteToExcelCOM(0,0,spc.fits{fc}.beta5);
        rng.NumberFormat='0.00';
        if spc.fits{fc}.fix_delta
            rng.Font.Italic=1;
        end
        
        % GAUSS WIDTH (if gaussian fit) (8)
        if strcmp(type,'gauss')
            rng=spc_WriteToExcelCOM(0,0,spc.fits{fc}.beta6);
            rng.NumberFormat='0.00';
            if spc.fits{fc}.fix_g
                rng.Font.Italic=1;
            end
        else
            spc_WriteToExcelCOM(0,0,'');
        end
        
        % POP1 (9) - just by fractional amplitude (should we scale by tau?)
        pop1=spc.fits{fc}.beta1/(spc.fits{fc}.beta1+spc.fits{fc}.beta3);
        % POP2 (10)
        pop2=spc.fits{fc}.beta3/(spc.fits{fc}.beta1+spc.fits{fc}.beta3);
        rng=spc_WriteToExcelCOM(0,0,pop1); rng.NumberFormat='0.0%';
        rng=spc_WriteToExcelCOM(0,0,pop2); rng.NumberFormat='0.0%';
        
        % Average TAU (11) (now weighted by tau)
        rng=spc_WriteToExcelCOM(0,0,spc.fits{fc}.avgTau); rng.NumberFormat='0.00';
        
        % TRUNCATED MEAN TAU (12)
        rng=spc_WriteToExcelCOM(0,0,spc.fits{fc}.avgTauTrunc); rng.NumberFormat='0.00';
        
    end % END if failed fit
    end % if opt.fitDetails
    
end %for fc=FLIMchannels

% save standard ROI analysis, if it exists:
try % because ROIScanName gives errors sometimes
    if opt.stdROIs
        if isfield(state,'analysis') && isfield(state.analysis,'numberOfROI')
            for iChan=state.analysis.analyzedChannels
                for roi=1:opt.maxROIs
                    if roi<=state.analysis.numberOfROI
                        rng=spc_WriteToExcelCOM(0,0,mean(ROIScanName(iChan,roi,state.files.lastAcquisition)));
                        rng.NumberFormat='0.0';
                    else
                        spc_WriteToExcelCOM(0,0,'');
                    end
                end
            end
        end
    end
catch errCode
    disp('spc_SaveFitToExcel: error in getting std ROI analysis results');
    disp(['>>>>> ' errCode.message]);
end
% Our code to segregate by cycle position
oldCol=spc.analysis.excelNextCol;
% Below was added for debugging.
% disp(['oldCol' num2str(oldCol)]);
% state.cycle.currentCyclePosition=1;
spc.analysis.excelNextCol=160;
spc_WriteToExcelCOM(0,0,state.cycle.currentCyclePosition)
spc.analysis.excelNextCol=spc.analysis.excelNextCol+state.cycle.currentCyclePosition-1;
rng=spc_WriteToExcelCOM(0,0,spc_calcEmpiricalMean(fc)); rng.NumberFormat='0.00';
spc.analysis.excelNextCol=oldCol;
% Below was added for debugging.
% disp(['NextCol' num2str(spc.analysis.excelNextCol)]);

% conclude the line:
spc_WriteToExcelCOM(0,1,[]);

% Yao's code to put data in waves.
spc_SaveFitToWave