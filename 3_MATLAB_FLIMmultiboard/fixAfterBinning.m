function fixAfterBinning(chan)
global spc gui
newSize=size(spc.projects{chan},1);
axis(gui.spc.lifetimeMaps{chan}.axes,[1 newSize 1 newSize]);
axis(gui.spc.projects{chan}.axes,[1 newSize 1 newSize]);