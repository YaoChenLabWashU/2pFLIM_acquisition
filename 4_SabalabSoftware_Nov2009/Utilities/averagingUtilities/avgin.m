function avgin(newData, avgName)
	n=avgNComponents(avgName);
	if ischar(newData)
		dataName=newData;
	else
		dataName=inputname(1);
    end
    
    disp([dataName ' added to ' avgName])
	if n<=0
		duplicateo(dataName, avgName);
		setWaveUserDataField(avgName, 'nComponents', 1);
		setWaveUserDataField(avgName, 'Components', {dataName});
	else
		avgData=getWave(avgName, 'data');
		if iswave(dataName)
			newDataData=getWave(dataName, 'data');
		else
			error('avgin: data must be in wave format');
		end

		len=min(length(avgData), length(newDataData));
		setWave(avgName, 'data', (avgData(1:len)*n+newDataData(1:len))/(n+1));
		setWaveUserDataField(avgName, 'nComponents', n+1);
		try
			comps=getWaveUserDataField(avgName, 'Components');
		catch
			comps={};
		end
		setWaveUserDataField(avgName, 'Components', [comps {dataName}]);
	end
		
		
			

	

	