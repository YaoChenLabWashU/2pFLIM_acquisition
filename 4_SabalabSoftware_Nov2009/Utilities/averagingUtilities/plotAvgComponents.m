function plotAvgComponents(avgName)
	if ~iswave(avgName)
		error('plotAvgComponents: input must be wave or wavename');
	elseif ~ischar(avgName)
		avgName=inputname(1);
	end
	
	comps=getWaveUserDataField(avgName, 'Components');
	if ~isempty(comps)
		for counter=1:length(comps)
			retreiveWave(comps{counter});
			if counter==1
				evalin('base', ['plot(' comps{counter} ');']);
			else
				evalin('base', ['append(' comps{counter} ');']);
			end
		end
		set(gcf, 'Name', ['Components of ' avgName ]);
		set(gcf, 'NumberTitle', 'off');
	end
	
		