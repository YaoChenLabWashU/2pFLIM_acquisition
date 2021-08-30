set(0,'DefaultFigurePosition',[-880 800 560 420])
waveUserDefaults('axisAutoScale', 2);
global state gh
state.analysisMode=0;

%%% TN 06 Apr 05

warning('off', 'MATLAB:dispatcher:InexactMatch');
warning('off', 'daq:daqmex:propertyConfigurationError');
 warning('off','MATLAB:dispatcher:InexactCaseMatch')
 try
     daqhwinfo('nidaq');
     disp('*** A/D INTERFACES FOUND.  STARTING UP IN ACQUISITION MODE ***');
 	disp('');
 catch
     disp('*** NO A/D INTERFACES FOUND.  STARTING UP IN ANALYSIS MODE ***');
 	disp('');
     beep
     state.analysisMode=1;
end
gh.chooser = guihandles(chooser);
close(gcf);
