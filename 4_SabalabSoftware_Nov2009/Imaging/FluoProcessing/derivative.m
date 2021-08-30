function out=derivative(in, dx)
	if nargin<2
		dx=1;
	end
	
	out=filter([1 -2 1], 1, in)/dx^2;
	