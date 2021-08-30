function plotButtonDwnFcn
%WindowButtonDownFcn function for class waves.

name=get(gcf,'Name');
if findstr('legend', name)
	return
end
set(gcf,'UserData',name);
axisname=get(gca,'Tag');
scaled=get(gca,'UserData');
if isstruct(scaled)  & isfield(scaled,'autoScale')
    scaled=scaled.autoScale;
else
    scaled=0;
end
set(gcf,'name',[axisname ' Scaled = ' num2str(scaled)]);
