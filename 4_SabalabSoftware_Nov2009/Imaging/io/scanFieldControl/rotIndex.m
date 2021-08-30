function [x2, y2]=rotIndex(x, y, angle, x0, y0, angle0)
	dx=x-x0;
	dy=y-y0;
	
	c = cos((angle0-angle)*pi/180);
	s = sin((angle0-angle)*pi/180);
	
	x2 =  c * dx + s * dy;
	y2 = -s * dx + c * dy;
	
	
	
