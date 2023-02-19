function spcGY_SaveFitToExcel
global spc state
if ~isfield(spc,'analysis') || ~isfield(spc.analysis,'excelChannel') ...
        || isempty(spc.analysis.excelChannel)
    return
end

% write a line to the excel channel
% parameter titles are specified in spcGY_OpenExcelFile
%
rng=spcGY_WriteToExcelCOM(0,0,spc.filename);
rng.HorizontalAlignment=4;

% time of acquisition
try 
    spcGY_WriteToExcelCOM(0,0,spc.datainfo.time);
catch
    spcGY_WriteToExcelCOM(0,0,0);
end
% extract file number
[pathstr, name, ext] = fileparts(spc.filename);
filenum = str2double(name(end-2:end));
spcGY_WriteToExcelCOM(0,0,filenum); % file number

% write the cycle position
HeaderFile=strcat(name(1:9),name(end-2:end),'_hdr.txt'); %Create the name of the HeaderFile that includes cycle position information.
CyclePosition=GrabCyclePosition(HeaderFile);    %Find Cycle Position from the Header File
spcGY_WriteToExcelCOM(0,0,CyclePosition);   %Write the cycle Position to Excel.

% laser wavelength and power
try 
    spcGY_WriteToExcelCOM(0,0,spc.datainfo.laser.wavelength);
catch
    spcGY_WriteToExcelCOM(0,0,'');
end
try
    spcGY_WriteToExcelCOM(0,0,spc.datainfo.laser.power);
catch
    spcGY_WriteToExcelCOM(0,0,'');
end

if isfield(spc.fit,'failedFit') && spc.fit.failedFit && spc.fit.redchisq>100 ...
        || spc.fit.redchisq > 1000
    % bad news - don't rewrite the fit parameters
    spcGY_WriteToExcelCOM(0,0,'failedFit');
    for k=1:12 %skip 12 columns
        spcGY_WriteToExcelCOM(0,0,'');
    end
else
% find fit type
if findstr('gauss',spc.fit.lastFitFunction)
    type='gauss';
elseif findstr('prf',spc.fit.lastFitFunction)
    type='prf';
elseif findstr('triple',spc.fit.lastFitFunction)
    type='triple';
else
    type='unknown';
end
spcGY_WriteToExcelCOM(0,0,type);

spcGY_WriteToExcelCOM(0,0,spc.fit.fitOrder);
rng=spcGY_WriteToExcelCOM(0,0,spc.fit.redchisq); rng.NumberFormat='0.00';
rng=spcGY_WriteToExcelCOM(0,0,spc.fit.beta0(1)); rng.NumberFormat='0';

% tau handling is special
tau1=spc.fit.beta0(2)*spc.datainfo.psPerUnit/1000;
rng=spcGY_WriteToExcelCOM(0,0,tau1); rng.NumberFormat='0.00';
if spc.fit.fixtau1
    rng.Font.Italic=1;
end

rng=spcGY_WriteToExcelCOM(0,0,spc.fit.beta0(3));
 rng.NumberFormat='0';
tau2=spc.fit.beta0(4)*spc.datainfo.psPerUnit/1000;
rng=spcGY_WriteToExcelCOM(0,0,tau2); rng.NumberFormat='0.00';
if spc.fit.fixtau2
    rng.Font.Italic=1;
end

rng=spcGY_WriteToExcelCOM(0,0,spc.fit.beta0(5)*spc.datainfo.psPerUnit/1000);
  rng.NumberFormat='0.00';
  if spc.fit.fix_delta
    rng.Font.Italic=1;
  end
if strcmp(type,'gauss')
  rng=spcGY_WriteToExcelCOM(0,0,spc.fit.beta0(6)*spc.datainfo.psPerUnit/1000);
  rng.NumberFormat='0.00';
  if spc.fit.fix_g
    rng.Font.Italic=1;
  end
else
  spcGY_WriteToExcelCOM(0,0,'');
end
handles=guihandles(spc_main);
rng=spcGY_WriteToExcelCOM(0,0,str2double(get(handles.F_offset,'String'))); rng.NumberFormat='0.00';
pop1=spc.fit.beta0(1)/(spc.fit.beta0(1)+spc.fit.beta0(3));
pop2=spc.fit.beta0(3)/(spc.fit.beta0(1)+spc.fit.beta0(3));
rng=spcGY_WriteToExcelCOM(0,0,pop1); rng.NumberFormat='0.0%';
rng=spcGY_WriteToExcelCOM(0,0,pop2); rng.NumberFormat='0.0%';
meanTau = (pop1*tau1*tau1 + pop2*tau2*tau2) / (pop1*tau1 + pop2*tau2);
rng=spcGY_WriteToExcelCOM(0,0,meanTau); rng.NumberFormat='0.00';

end % END if failed fit


rng=spcGY_WriteToExcelCOM(0,0,spcGY_calcEmpiricalMean); rng.NumberFormat='0.00';

% save ROI analysis, if it exists:
if isfield(state,'analysis') && isfield(state.analysis,'numberOfROI')
  for roi=1:state.analysis.numberOfROI
    for iChan=state.analysis.analyzedChannels
        rng=spcGY_WriteToExcelCOM(0,0,mean(ROIScanName(iChan,roi,state.files.lastAcquisition)));
        rng.NumberFormat='0.0';
    end
  end
end

% added in for the gy-ROIs; and modified for ROI analysis segregation by
% cycle position.
global gui
if isfield(gui,'gy') && isfield(gui.gy,'ROIvals')
    vals=reshape(gui.gy.ROIvals',[],1);
    fmts={'0.0' '0.0' '0.0' '0.00' '0'};
    for k=1:length(vals)
        rng=spcGY_WriteToExcelCOM(0,0,vals(k),52+k); rng.NumberFormat=fmts{mod(k-1,5)+1};
        rng=spcGY_WriteToExcelCOM(0,0,vals(k),160+k+CyclePosition*6-1);rng.NumberFormat='0.00';
    end
end

% Our code to segregate by cycle position
oldCol=spc.analysis.excelNextCol;

spc.analysis.excelNextCol=150;
spcGY_WriteToExcelCOM(0,0,CyclePosition);
spc.analysis.excelNextCol=spc.analysis.excelNextCol+CyclePosition-1;
rng=spcGY_WriteToExcelCOM(0,0,spcGY_calcEmpiricalMean); rng.NumberFormat='0.00';

spc.analysis.excelNextCol=oldCol;

% conclude the line:
spcGY_WriteToExcelCOM(0,1,[]);
