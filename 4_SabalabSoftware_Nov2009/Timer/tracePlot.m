function tracePlot(newFigure, peaks, anaLine, anaPeak)
	global state
	if nargin==2
		anaLine=state.analysis.displayLine;
		anaPeak=state.analysis.displayPeak;
	elseif nargin==3
		anaPeak=state.analysis.displayPeak;
	elseif nargin<2
		error('tracePlot : needs 2 arguments at least');
	end
	
	traces=state.analysis.setup{anaLine, 8};
	colors='brkgmcybrkgmcy';
	if ~newFigure
		k=waitforbuttonpress;
		if isempty(findobj(gcf, 'Type', 'axes'))
			disp('*** NO axes***');
			return
		end
		all=showWaves(gcf);
		offset=0;
		for counter=1:length(all);
			if peaks
				if findstr('_pk', all{counter})
					offset=offset+1;
				end
			else
				if findstr('_bl', all{counter})
					offset=offset+1;
				end
			end				
		end
	else
		offset=0;
	end
  		
	if ~peaks
		first=1;
		marker='+++++++xxxxxxx';	
		for counter=1:length(traces)
			wname=[traces{counter} '_bl'];
			if ~iswave(wname)
				disp(['tracePlot : ' wname ' is missing.  Skipping...']);
			else
				if first & newFigure
					plotxy('timerAcqTime', wname);
					first=0;
				else
					appendxy('timerAcqTime', wname);
				end
				setPlotProps(wname, 'linestyle', 'none', 'marker', marker(counter+offset), 'markerFaceColor', colors(counter+offset), 'markerEdgeColor', colors(counter+offset))
			end
		end
	else
		first=1;
		totalCounter=1;
		marker='ooooooosssssss';
		for counter=1:length(traces)
			done=0;
			peakCounter=1;
			while ~done
				wname=[traces{counter} '_pk' num2str(peakCounter)];
				if ~iswave(wname)
					done=1;
				else
					if first & newFigure
						plotxy('timerAcqTime', wname);
						first=0;
					else
						appendxy('timerAcqTime', wname);
					end
					setPlotProps(wname, 'linestyle', 'none', 'marker', marker(counter+offset), 'markerFaceColor', colors(totalCounter+offset))
					totalCounter=totalCounter+1;
				end
				peakCounter=peakCounter+1;
			end
		end
	end		