function out=waveUserDefaults(param, value)
	persistent defaults
	if ~exist('defaults')
		defaults=[];
	end
	if nargin==1
		try
			out=getfield(defaults, param);
		catch
			out=[];
		end
	elseif nargin==2
		try 
			defaults=setfield(defaults, param, value);
		catch
			disp('waveUserDefaults : assignment failed');
		end
	else
		error('waveUserDefaults : param name or param name and value expected');
	end
				