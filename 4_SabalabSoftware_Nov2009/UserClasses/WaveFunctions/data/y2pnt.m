function out=y2pnt(waveName, y)
	out=[];
	if nargin~=2
		error('y2pnt : expect wave/waveName and y value as inputs');
	end		
	if ~iswave(waveName) | ~isnumeric(y)
		error('y2pnt : expect wave/waveName and y value as inputs');
	end
	if ~ischar(waveName)
		ys=waveName.yscale;        out=min(max(round(1+(y-ys(1))/ys(2)),1), size(waveName.data,1));
	else
		props=get(waveName, 'yscale', 'data');
		ys=props.yscale;
        out=min(max(round(1+(y-ys(1))/ys(2)),1), size(props.data,1));
	end
	
	