function plotWaveDeleteFcn
% This function clears the plot references from the waves on the plot
% When the plot is deleted or the figure is closed that contains the plot.
% If the wave is killed but not the plot, it is killed on closing.
try
	a = [findobj(gcf, 'Type', 'line'); findobj(gcf, 'Type', 'image')];	% Get all plots
	userdata = get(a, 'UserData'); % Look in UserData.
	
	if ~iscell(userdata)
		userdata={userdata};
	end
	
	for counter = 1:length(a)	
		if isfield(userdata{counter}, 'name') 
			nameCell=userdata{counter}.name;
			for nameCounter=1:length(nameCell)	% Look through the name list
				if ~isempty(nameCell{nameCounter})	
					if iswave(nameCell{nameCounter})
						plots = getWave(nameCell{nameCounter},'plot'); %evalin('base', [nameCell{nameCounter} '.plot']);
						if ~isempty(plots)
                            index = find(plots==a(counter));   % Find which element of plots is bad
                        else
                            index=[];
                        end
						if ~isempty(index)
							plots(index)=[];             % Remove bad handles
							if isempty(plots)
								plots=[];
							end
							setWave(nameCell{nameCounter}, 'plot', plots);
						end
					end
				end
			end
		end
	end
	closereq
catch
	closereq
	disp('plotWaveDeleteFcn : Waves not found in Plot Close');
	error(['plotWaveDeleteFcn : ' lasterr]);
end
