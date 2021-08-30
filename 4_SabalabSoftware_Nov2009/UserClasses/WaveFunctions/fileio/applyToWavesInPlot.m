function applyToWavesInPlot(arg1, arg2)
% relinks a plot to waves in memory
% Bernardo Sabatini
% Dec 11, 2002
% updated with new function for show waves...

	if nargin==1
		funcCall=arg1;
		h=gcf;
	elseif nargin==2
		funcCall=arg2;
		h=arg1;
	else
		error('applyToWavesInPlot : expected optional figure handle and function call string as arguments');
    end
	if ~istype(h,'figure')
		error('applyToWavesInPlot: input argument must be figure handle');
	end
	    a = [findobj(h, 'Type', 'line'); findobj(h, 'Type', 'image')];	% Get all plots
	userdata = get(a, 'UserData'); % Look in UserData.
	if ~iscell(userdata)
		userdata={userdata};
	end
	for	name = showWaves(h,2)
		try
			funcCallRep = strrep(funcCall, '%s', name{1});
			evalin('base', funcCallRep);
		catch
			disp(['applyToWaveInPlot : error in executing ' funcCallRep ]);
			disp(lasterr);
		end
	end