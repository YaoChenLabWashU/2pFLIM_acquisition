function avgout(newData, avgName, flags)
	if nargin<3
		flags='';
	end
	if ~ischar(newData)
		newData=inputname(1);
	end

	comps=avgComponentList(avgName);
	n=length(comps);
	first=1;
	
	namePos=find(strcmp(comps, newData));
	while ~isempty(namePos)
		first=0;
		if n==1
			resetAverage(avgName);
		else
			namePos=namePos(1);
			avgData=get(avgName, 'data');
			if iswave(newData)
				newDataData=get(newData, 'data');
			else
				error('avgout: data is not wave format');
			end
	
			len=min(length(avgData), length(newDataData));
			
			setWave(avgName, 'data', (avgData(1:len)*n-newDataData(1:len))/(n-1));
			setWaveUserDataField(avgName, 'nComponents', n-1);
			comps=getWaveUserDataField(avgName, 'Components');
			if namePos==1
				comps=comps(2:end);
			elseif namePos==length(comps)
				comps=comps(1:end-1);
			else
				comps=[comps(1:namePos-1) comps(namePos+1:end)];
			end
			setWaveUserDataField(avgName, 'Components', comps);
		end
		comps=avgComponentList(avgName);
		n=length(comps);	
		namePos=find(strcmp(comps, newData));
	end
	if first
		error(['avgout: ' newData ' is not a component of ' avgName ]);
	end
	
		

	