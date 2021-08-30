function bin2x2FLIMdata(chan)
global spc gui
% reduce by 2x in each dimension and gaussian filter both the lifetimeMap
% and the projection image
spc.lifetimeMaps{chan}=impyramid(spc.lifetimeMaps{chan},'reduce');
spc.projects{chan}=impyramid(spc.projects{chan},'reduce');
spc_makeRGBLifetimeMap(chan);
% and now redisplay them
set(gui.spc.lifetimeMaps{chan}.image, 'CData', spc.rgbLifetimes{chan});
set(gui.spc.lifetimeMaps{chan}.axes, 'XTick', [], 'YTick', []);
newSize=size(spc.projects{chan},1);
axis(gui.spc.lifetimeMaps{chan}.axes,[1 newSize 1 newSize]);

%axes(gui.spc.projects{chan}.axes);
set(gui.spc.projects{chan}.projectImage, 'CData', spc.projects{chan}, 'CDataMapping', 'scaled');
axis(gui.spc.projects{chan}.axes,[1 newSize 1 newSize]);


