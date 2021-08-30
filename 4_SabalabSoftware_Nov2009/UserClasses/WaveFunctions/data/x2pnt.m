function out=x2pnt(waveName, x)
	out=[];
	if nargin~=2
		error('x2pnt : expect wave/waveName and x value as inputs');
	end		
	if ~iswave(waveName) | ~isnumeric(x)
		error('x2pnt : expect wave/waveName and x value as inputs');
	end
	if ~ischar(waveName)
		xs=waveName.xscale;
		mx=size(waveName.data, 2);
	else	
		xs=getWave(waveName, 'xscale');
		mx=size(get(waveName, 'data'), 2);
	end
	out=min(max(round(1+(x-xs(1))/xs(2)),1), mx);
	
	