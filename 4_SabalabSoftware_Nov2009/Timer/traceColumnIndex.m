function varargout=traceColumnIndex(name, phys)
	global state

	new=0;
	if phys
		index=find(strcmp(name, state.analysis.usedPC));
		if isempty(index)
			state.analysis.usedPC{end+1}=name;
			index=length(state.analysis.usedPC);
			new=1;
		end
	else
		index=find(strcmp(name, state.analysis.usedIC));
		if isempty(index)
			state.analysis.usedIC{end+1}=name;
			index=length(state.analysis.usedIC);
			new=1;
		end
	end
	if new & ~isempty(state.internal.excelChannel) & state.files.autoSave 
		try
			ddepoke(state.internal.excelChannel, ['r25' 'c' num2str(50*phys+59+index)], name);
		catch
			disp('traceColumnIndex : unable to link to excel');
		end
	end

	varargout{1}=index;
	if nargout==2
		varargout{2}=new;
	end
		