function n=avgNComponents(name)
% returns the number of components in an average
	if ~ischar(name)
		name=inputname(1);
	end

	if iswave(name)
		n=getWaveUserDataField(name, 'nComponents');
		if isempty(n)
			n=0;
		end
	else
		n=0;
	end

