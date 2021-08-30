function updateGuiByStruct(startingName);
	if evalin('base', ['~isstruct(' startingName ')'])
		updateGUIByGlobal(startingName);
	else
		[topName, structName, fieldName]=structNameParts(startingName);
		eval(['global ' topName]);
		if ~exist(topName, 'var')
			return 
		end
		if length(fieldName)==0
			fieldName=topName;
		end
		eval(['fNames=fieldnames(' startingName ');']);
		for i=1:length(fNames)
			if evalin('base', ['isstruct(' [startingName '.' fNames{i}] ')'])
				try
					updateGuiByStruct([startingName '.' fNames{i}]);
				catch
					lasterr
				end
			elseif evalin('base', ['isnumeric(' [startingName '.' fNames{i}] ') | ischar(' [startingName '.' fNames{i}] ')'])
				try
					updateGUIByGlobal([startingName '.' fNames{i}]);
				catch
					lasterr
				end
			end
		end
	end
