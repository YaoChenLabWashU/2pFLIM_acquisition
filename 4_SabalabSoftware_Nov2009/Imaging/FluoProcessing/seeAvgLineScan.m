function seeAvgLineScan
	if ~iswave('avgLineScanWave')
		waveo('avgLineScanWave', []);
	end
	global avgLineScanWave

	colorList='brkgmcy';

	plot(avgLineScanWave);
	setPlotProps(avgLineScanWave, 'color', 'black');	
	append('offsetWave', 'color', 'black', 'lineStyle', '--');
	for counter=1:4
		if ~iswave(['roi_' num2str(counter) 'x'])
			if counter<=2
				wave(['roi_' num2str(counter) 'x'], []);
				wave(['roi_' num2str(counter) 'y'], []);
				evalin('base', ['appendxy(roi_' num2str(counter) 'x, roi_' num2str(counter) 'y);']);
				setPlotProps(['roi_' num2str(counter) 'y'], 'color', colorList(counter), 'LineWidth', 2.5);	
			end
		else
			evalin('base', ['appendxy(roi_' num2str(counter) 'x, roi_' num2str(counter) 'y);']);
			setPlotProps(['roi_' num2str(counter) 'y'], 'color', colorList(counter), 'LineWidth', 2.5);	
		end
	end
	drawnow
	set(gcf, 'Name', 'AVG LINE SCAN');
	set(gcf, 'NumberTitle', 'off');
	
		