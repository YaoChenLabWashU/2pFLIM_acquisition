function out=pnt2x(waveName, p)
	out=[];	if nargin~=2
		error('pnt2x : expect wave/waveName and point number as inputs');
	end		
	if ~iswave(waveName) | ~isnumeric(p)
		error('pnt2x : expect wave/waveName and point number as inputs');
	end
	if ~ischar(waveName)
		waveName=inputname(1);
	end
	xs=getWave(waveName, 'xscale');
	out=xs(1)+xs(2)*(p-1);
	
