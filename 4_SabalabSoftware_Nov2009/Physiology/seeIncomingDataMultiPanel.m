function seeIncomingDataMultiPanel(channels)
	global state
	
	if nargin<1 || isempty(channels)
		channelList=zeros(1,8);
		for channel=0:7
			if getfield(state.phys.settings, ['acq' num2str(channel)]) && getfield(state.phys.settings, ['disp' num2str(channel)])
				channelList(channel+1)=1;
			end
		end
		channels=find(channelList)-1;
	end
	
	counter=1;		
	sq=floor(sqrt(length(channels)));
	
	if sq==sqrt(length(channels))
		xl=sq;
		yl=sq;
	else
		xl=sq;
		yl=sq+1;
		if xl*yl<length(channels)
			xl=xl+1;
		end
	end
	
	for channel=channels
		if ~iswave(['dataWave' num2str(channel)])
			wave(['dataWave' num2str(channel)], []);
		end
		eval(['global dataWave' num2str(channel) ]);
		if counter==1
	        f=figure('Color', 'w', 'DoubleBuffer', 'on', 'CloseRequestFcn', 'plotWaveDeleteFcn','KeyPressFcn','plotKeyPressFcn',...
		          'WindowButtonDownFcn','plotButtonDwnFcn','WindowButtonUpFcn','plotButtonUpFcn');			
			state.phys.internal.dataPlot=gcf;
			set(gcf, 'NumberTitle', 'off', 'Name', 'INCOMING DATA');
		end
		subplot(xl,yl,counter);
		append(['dataWave' num2str(channel)]);
		title(['channel ' num2str(channel)]);
		counter=counter+1;
	end

