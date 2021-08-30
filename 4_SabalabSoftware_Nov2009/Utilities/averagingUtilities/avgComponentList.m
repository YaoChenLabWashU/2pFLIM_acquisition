function n=avgComponentList(name)
% returns the waves that make up an average

	if ~ischar(name)
		name=inputname(1);
	end
	if iswave(name)
		n=getWaveUserDataField(name, 'Components');
	else
		n='';
	end

