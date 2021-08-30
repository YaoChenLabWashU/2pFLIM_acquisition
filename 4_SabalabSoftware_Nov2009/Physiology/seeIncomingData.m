function seeIncomingData(channelList)
	global state
	
	if nargin<1
		channelList=[0:7];
	end
	
	persistent colors
	
	if ~iscell(colors)
		colors={'red', 'black', 'blue', 'green', 'yellow', 'gray', 'gray', 'gray'};
	end

	first=1;
	h=[];
	title='INCOMING DATA AD';
	
    channelIndex=1;
	for channel=channelList
		if getfield(state.phys.settings, ['acq' num2str(channel)]) && getfield(state.phys.settings, ['disp' num2str(channel)])
			if ~iswave(['dataWave' num2str(channel)])
				wave(['dataWave' num2str(channel)], []);
			end
			eval(['global dataWave' num2str(channel) ]);
			title=[title ' ' num2str(channel)];
			if first
				eval(['plot(' 'dataWave' num2str(channel) ');']);
				state.phys.internal.dataPlot=gcf;
				h=gcf;
				eval(['setPlotProps(dataWave' num2str(channel) ', ''color'', ''' colors{channelIndex} '''); ']);
				set(gcf, 'NumberTitle', 'off');
				first=0;
			else
				figure(gcf);
				eval(['append(' 'dataWave' num2str(channel) ');']);
				eval(['setPlotProps(dataWave' num2str(channel) ', ''color'', ''' colors{channelIndex} '''); ']);
            end
        channelIndex=channelIndex+1;
		end
	end

	if ishandle(h)
		set(gcf, 'Name', title);
	end

