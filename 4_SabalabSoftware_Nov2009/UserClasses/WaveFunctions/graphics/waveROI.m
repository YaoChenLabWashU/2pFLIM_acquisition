function [varargout]=waveROI(wavename)
% This function allows a wave to be created frm the selection of a 2D plot....
% with coordinates from a rectangle and tied to a plot.
% The rectangle is sleected via the mouse on the current axis.
% The section is written as a wavew with the name wavename.

if nargin ~=1
	error('waveRect: must supply wavename as string.');
else
	if ~ischar(wavename)
		error('waveRect: must supply wavename as string.');
	end
end

objs=findobj('Type', 'axes');  % Are there any axes?
if ~isempty(objs)              
	ax=gca;
else
	error('waveROI: must have an image to do this correctly'); % nothing to remove....
end

images = findobj(ax, 'type', 'image');
if isempty(images)  % no images....function is not defined.
	error('waveROI: must have an image to do this correctly');
end
images = images(1);
rect = getrect(ax);
startX=round(rect(1));
startY=round(rect(2));
stopX=round(startX+rect(3));
stopY=round(startY+rect(4));
Cdata = get(images, 'CData');

data = Cdata(startY:stopY,startX:stopX);
c=wave(wavename, data);
if c
	disp(['Declared ' wavename ' as a global wave']);
end

if nargout == 1
	varargout{1}=rect;
end

