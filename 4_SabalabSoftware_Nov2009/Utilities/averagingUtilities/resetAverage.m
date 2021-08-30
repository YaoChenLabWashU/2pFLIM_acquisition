function resetAverage(name)
	if ~ischar(name)
		name=inputname(1);
	end
	if iswave(name)
		setWave(name, 'data', []);
		setWaveUserDataField(name, 'nComponents', 0);
		setWaveUserDataField(name, 'Components', {});
	end
		
		