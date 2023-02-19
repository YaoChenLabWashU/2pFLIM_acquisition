function YaoMedianFilter(chan)
global spc gui
% Median filter both the lifetimeMap and the projection image 2X2.
spc.lifetimeMaps{chan}=medfilt2(spc.lifetimeMaps{chan},[3 3]);
spc.projects{chan}=medfilt2(spc.projects{chan},[3 3]);
spc_makeRGBLifetimeMap(chan);
% and now redisplay them
set(gui.spc.lifetimeMaps{chan}.image, 'CData', spc.rgbLifetimes{chan});
set(gui.spc.lifetimeMaps{chan}.axes, 'XTick', [], 'YTick', []);
newSize=size(spc.projects{chan},1);
axis(gui.spc.lifetimeMaps{chan}.axes,[1 newSize 1 newSize]);

%axes(gui.spc.projects{chan}.axes);
set(gui.spc.projects{chan}.projectImage, 'CData', spc.projects{chan}, 'CDataMapping', 'scaled');
axis(gui.spc.projects{chan}.axes,[1 newSize 1 newSize]);


