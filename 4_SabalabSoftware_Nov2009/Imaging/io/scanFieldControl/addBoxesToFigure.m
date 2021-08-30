function addBoxesToFigure

	for counter=1:settingsManager('getsetlength', 'pcellBox') 		% loop through each box
		% is the box active?
		if settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxActiveStatus') 	
			x1=settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxStartX');		% extact the coordinates
			x2=settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxEndX');
			y1=settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxStartY');
			y2=settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxEndY');
			if x1>=1 & x2>=1 & y1>=1 & y2>=1
				line([x1 x2 x2 x1 x1], [y1 y1 y2 y2 y1], ...
					'Parent', gca, 'LineWidth', 1, 'color', 'cyan');
				text(x1+6, y1+6, num2str(counter), ...
					'Parent', gca, 'color', 'blue');
			end
		end
	end
