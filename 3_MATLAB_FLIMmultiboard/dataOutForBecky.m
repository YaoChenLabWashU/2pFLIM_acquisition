function dataOutForBecky
global becky spc gui
evalin('base','global becky');
% col 1 = timebase
% col 2 = lifetime data
% col 3 = fit curve
% col 4 = range0, range1, 
nsPerBin=spc.datainfo.psPerUnit/1000;
becky(:,1)=(1:64)*spc.datainfo.psPerUnit/1000;
becky(:,2)=spc.lifetime(:);
becky(:,3)=0;
becky(spc.fit.range(1):spc.fit.range(2),3)=spc.fit.curve(:);
becky(:,4)=0;
becky(1:2,4)=spc.fit.range(:);
becky(3:8,4)=spc.fit.beta0(:).*[1 nsPerBin 1 nsPerBin nsPerBin nsPerBin]';
% note that the tau's, deltaPk, and gaussian width are stored in points
% and need to be reported in nS.
handles=gui.spc.spc_main;
becky(9,4)=str2double(get(handles.F_offset,'String'));
becky(10,4)=spc.fit.avgTau;
becky(11,4)=spc.fit.avgTauTrunc;
becky(12,4)=spc.fit.fitOrder;
becky(13,4)=str2double(get(handles.File_N,'String'));
becky(14:17,4)=[spc.fit.fixtau1 spc.fit.fixtau2 spc.fit.fix_delta spc.fit.fix_g]';

