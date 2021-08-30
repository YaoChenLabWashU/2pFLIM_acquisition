function reactivateWavePlot(h, updateTimeStamps)
% relinks a plot to waves in memory
% Bernardo Sabatini
% Dec 11, 2002
	if nargin<1
		h=gcf;
		updateTimeStamps=1;
	elseif nargin<2
		updateTimeStamps=1;
	end
	if ~istype(h,'figure')
		error('reactivateWavePlot: input argument must be figure handle');
	end
	a = [findobj(h, 'Type', 'line'); findobj(h, 'Type', 'image')];	% Get all plots
	userdata = get(a, 'UserData'); % Look in UserData.
	if ~iscell(userdata)
		userdata={userdata};
	end
	for i = 1:length(a)	
		if isfield(userdata{i}, 'name') 
			nameCell=userdata{i}.name;
			for j=1:length(nameCell)	% Look through the name list
				if ~isempty(nameCell{j})	% not empty
					if ~evalin('base', ['exist(''' nameCell{j} ''')'])
						disp(['reactiveWavePlot : creating empty wave ' nameCell{j}]);
						wave(nameCell{j}, []);
					else
						disp(['reactivateWavePlot: Linkint to ' nameCell{j} ]);
					end
					if iswave(nameCell{j})
						plots=getWave(nameCell{j}, 'plot');
						if ~any(plots==a(i))
							if isempty(plots)
								plots=a(i);
							else
								plots=[plots a(i)];
							end
							setWave(nameCell{j}, 'plot', plots);
						end
						if updateTimeStamps
							userdata{i}.timeStamp(j)=getWave(nameCell{j}, 'timeStamp');
						end
					else
						disp(['reactivateWavePlot: Warning: ' nameCell{j} ' exists and is not a wave. Can not fully reactivate plot']);
					end
				end
				if updateTimeStamps
					set(a(i), 'UserData', userdata{i});
				end
			end
		end
	end
	updatePlots(h);