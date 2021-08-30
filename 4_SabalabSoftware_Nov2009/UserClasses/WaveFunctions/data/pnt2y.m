function out=pnt2y(waveName, p)
	out=[];
	if nargin~=2
		error('pnt2y : expect wave/waveName and point number as inputs');
	end		
	if ~iswave(waveName) | ~isnumeric(p)
		error('pnt2y : expect wave/waveName and point number as inputs');
	end
	if ~ischar(waveName)
		waveName=inputname(1)
	end
	props=get(waveName, 'yscale');
	ys=props.yscale;
	out=ys(1)+ys(2)*p;
	