function makeGraphicalLUT
% THis will make a grpahical interface for editing
% the LUT for the ScanImage software.
% Each channel is represented by a different plot.
% green = channel 1
% red = channel 2;
% black = channel 3
% The middle point controsl the highPixelValue of the respective channel.

global state gh
state.internal.graphicalLUTFig=figure('NumberTitle','off','name','Graphical LUT', 'DoubleBuffer','on','color','white','visible','off',...
	'CloseRequestFcn','set(gcf,''visible'',''off'')');
a1=axes('Parent',state.internal.graphicalLUTFig,'NextPlot','Add');
set(get(a1,'XLabel'),'String','Channels');
set(get(a1,'YLabel'),'String','High Pixel Value');
title('Graphical LUT for ScanImage');
ch1=plot([0 1 2],[3000 state.internal.highPixelValue1 state.internal.lowPixelValue1], ...
    'tag','channel1','color','green','marker','o');
ch2=plot([0 1 2],[3000 state.internal.highPixelValue2 state.internal.lowPixelValue2], ...
    'tag','channel2','color','red','marker','o');
ch3=plot([0 1 2],[3000 state.internal.highPixelValue3 state.internal.lowPixelValue3], ...
    'tag','channel3','color','black','marker','o');
legend('Channel 1', 'Channel 2', 'Channel 3');
movePlot(ch1,'y');
movePlot(ch2,'y');
movePlot(ch3,'y');
 
