function spc_makeRoi(chan)
global spc
global gui

waitforbuttonpress;
figure(gui.spc.projects{chan}.figure);
point1 = get(gca,'CurrentPoint');    % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(gca,'CurrentPoint');    % button up detected
point1 = point1(1,1:2);              % extract x and y
point2 = point2(1,1:2);
p1 = min(point1,point2);             % calculate locations
offset = abs(point1-point2);         % and dimensions
%rectangle('Position', [p1, offset]);
spc_roi = round([p1, offset]);
set(gui.spc.projects{chan}.roi, 'Position', spc_roi);
set(gui.spc.lifetimeMaps{chan}.mapRoi, 'Position', spc_roi);
spc_drawLifetime(chan);