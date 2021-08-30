function baselineSubtract(waveName, start, stop, pt)
	if iswave(waveName)
		if ~ischar(waveName)
			waveName=inputname(1);
		end
	else
		error('baselineSubtract : expect wave or waveName as first input');
	end
	
	if nargin==3
		pt=0;
	end
	
	data=getWave(waveName, 'data');
	if pt
		bl=mean(data(start:stop));
	else
		bl=mean(data(x2pnt(waveName, start):x2pnt(waveName, stop)));
	end
	
	setWave(waveName, 'data', data-bl);
	
	