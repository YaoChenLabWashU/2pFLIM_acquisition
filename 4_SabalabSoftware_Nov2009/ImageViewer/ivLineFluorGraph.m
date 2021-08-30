function ivLineFluorGraph
	global state
	
	colorList='grbygrbyyygrbygrbyyy';
	for channel=[1:8 11:18];
		waveo(['ivLineFluorOffset' num2str(channel)], []);
		if channel==1
			plot(['ivLineFluorOffset' num2str(channel)]);
			set(gcf, 'NumberTitle', 'off');
			set(gcf, 'Name', 'Line Fluor Analysis');
			setPlotProps(['ivLineFluorOffset' num2str(channel)], 'color', colorList(channel));
		elseif channel<=4
			append(['ivLineFluorOffset' num2str(channel)]);
			setPlotProps(['ivLineFluorOffset' num2str(channel)], 'color', colorList(channel));
		end

		waveo(['ivLineFluor' num2str(channel)], []);
		append(['ivLineFluor' num2str(channel)]);
		setPlotProps(['ivLineFluor' num2str(channel)], 'color', colorList(channel));
		if (channel>4 & channel<=10) | channel>14
			setPlotProps(['ivLineFluor' num2str(channel)], 'LineWidth', 2);
		end
		if channel>10
			setPlotProps(['ivLineFluor' num2str(channel)], 'LineStyle', '--');
		end
		waveo(['ivLineFluorWidth' num2str(channel)], 0);
		append(['ivLineFluorWidth' num2str(channel)])		;
		setPlotProps(['ivLineFluorWidth' num2str(channel)], 'color', colorList(channel));
		if (channel>4 & channel<=10) | channel>14
			setPlotProps(['ivLineFluorWidth' num2str(channel)], 'LineWidth', 2);
		end
		if channel>10
			setPlotProps(['ivLineFluorWidth' num2str(channel)], 'LineStyle', '--');
		end

	end