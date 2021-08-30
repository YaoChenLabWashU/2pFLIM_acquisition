function [x, y]=getBoxCoords(imageHandle, sortCoords)
	if nargin>0
		if ~isempty(imageHandle)
			figure(imageHandle);
		end
	end
	if nargin<2
		sortCoords=0;
	end
	
	disp('*** DRAG ROI OVER WINDOW ***');
	k = waitforbuttonpress;
	
	x=[];
	y=[];

	if isempty(findobj(gcf, 'Type', 'axes'))
		disp('*** NO axes found.  returning ***');
		return
	end
		
		
	point1 = get(gca,'CurrentPoint');    % button down detected
	finalRect = rbbox;                   % return figure units
	point2 = get(gca,'CurrentPoint');    % button up detected
	y=round([point1(1,1) point2(1,1)]);
	x=round([point1(1,2) point2(1,2)]);
	if sortCoords==1 	% sort by X
		[x, I]=sort(x);
		y=y(I);
	elseif sortCoords==2 % sort by Y
		[y, I]=sort(y);
		x=x(I);
	end