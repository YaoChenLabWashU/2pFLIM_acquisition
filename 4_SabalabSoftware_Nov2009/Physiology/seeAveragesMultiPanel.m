function seeAveragesMultiPanel(pulses, channels) 
	global state
	
	if nargin==0
		if state.cycle.useCyclePos
			pulses=find(state.cycle.physOnList);
		else
			pulses=unique(state.cycle.da0List);
		end
		
	end
	
	if nargin<2 || isempty(channels)
		channelList=zeros(1,8);
		for channel=0:7
			if getfield(state.phys.settings, ['acq' num2str(channel)]) && getfield(state.phys.settings, ['avg' num2str(channel)])
				channelList(channel+1)=1;
			end
		end
		channels=find(channelList)-1;
	end

	counter=1;
		
	if (length(pulses)>1) && (length(channels)>1)
		xl=length(channels);
		yl=length(pulses);
	else
	 	sq=sqrt(length(pulses)*length(channels));
 	
		if sq==floor(sq)
			xl=sq;
			yl=sq;
		else
			xl=ceil(sq);
			if (xl*floor(sq))>=(length(pulses)*length(channels))
				yl=floor(sq);
			else
				yl=ceil(sq);
			end
		end
	end

	xcounter=0;
	for pulse=pulses
		ycounter=0;
		for channel=channels

			name=physAvgName(state.epoch, channel, pulse);
			if ~iswave(name);
				wave(name, []);
			end

			if counter==1
				f=figure('Color', 'w', 'DoubleBuffer', 'on', 'CloseRequestFcn', 'plotWaveDeleteFcn','KeyPressFcn','plotKeyPressFcn',...
					  'WindowButtonDownFcn','plotButtonDwnFcn','WindowButtonUpFcn','plotButtonUpFcn');			
				set(gcf, 'Name', ['EPOCH ' num2str(state.epoch) ', Chan: ' num2str(channels) ', Pulse: ' num2str(pulses)], ...
					'NumberTitle', 'off');
			end
	%		subplot(yl,xl,ycounter*xl+xcounter+1);	%
			subplot(yl,xl,counter);
			append(name);
			%title('test\_ad')
			title(regexprep(name, '_', '\\_'));
			counter=counter+1;
			ycounter=ycounter+1;
		end
		xcounter=xcounter+1;

	end
	



