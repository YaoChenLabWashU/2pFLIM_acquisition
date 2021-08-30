function out=extractWaveAcqTime(wave)
	if iswave(wave) & ~ischar(wave)
		wave=inputname(1);
	end
	out=str2num(extractFromWaveHeader(wave, 'state.phys.cellParams.minInCell0'));