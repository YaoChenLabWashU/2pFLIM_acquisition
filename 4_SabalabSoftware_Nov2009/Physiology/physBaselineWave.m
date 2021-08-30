function physBaselineWave(waveName, baseline)
	if ~iswave(waveName)
		error('physBaselineWave: expected wave name');
	else
		xscale=get(waveName, 'xscale');
		baselineStart=max(ceil(baseline(1)/xscale(2)),1);
		baselineEnd=min(floor(baseline(2)/xscale(2)));
		
		evalin('base', [waveName '.data=' waveName '.data-mean(' waveName ...
				'(' num2str(baselineStart) ':min(end,' num2str(baselineEnd) ')));'])
	end