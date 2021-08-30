function out=extractFromWaveHeader(wave, param)
	if iswave(wave) & ~ischar(wave)
		wave=inputname(1);
	end
	try
		header=getfield(get(wave, 'UserData'), 'headerString');
	catch
		header=[];
	end
	out=headerValue(header, param);
	
