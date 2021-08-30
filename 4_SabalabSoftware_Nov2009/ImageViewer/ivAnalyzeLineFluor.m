function ivAnalyzeLineFluor
	global gh state bit
	% bit is 0 if it is a normal point and 1 if it si an extension.
	bit = [];
	peaks=[];

	if state.imageViewer.selectionChannel<=4
		figure(state.imageViewer.figure(state.imageViewer.selectionChannel));
	elseif state.imageViewer.selectionChannel<=8
		figure(state.imageViewer.projFigure(state.imageViewer.selectionChannel-4));
	elseif state.imageViewer.selectionChannel==9
		figure(state.imageViewer.compositeFigure);
	end
	
	[x,y]=ginput(2);
	if size(x,1)~=2
		return
	end
	
	state.imageViewer.lineData=[];
	state.imageViewer.lineMin=zeros(1,4);
	state.imageViewer.lineMax=zeros(1,4);
	state.imageViewer.lineHW=zeros(1,4);
	state.imageViewer.lineHWAvg=zeros(1,4);
	state.imageViewer.lineAvg=zeros(1,4);
	state.imageViewer.lineOffset=zeros(1,4);
	
	for channel=find(state.imageViewer.channelsOn)
		data=improfile(state.imageViewer.stackData{channel}(:,:,state.imageViewer.displayedSlice), x, y);	
		if state.imageViewer.smoothingWidth>1
			data=smooth(data', state.imageViewer.smoothingWidth)';
		end

		offset=getfield(state.imageViewer, ['offsetChannel' num2str(channel)]);
		minData=min(data);
		if state.imageViewer.offsetMode==1
			data=data-offset;
			waveo(['ivLineFluorOffset' num2str(channel)], zeros(1, size(data,1)));
			state.imageViewer.lineOffset(channel)=min(offset);
		elseif state.imageViewer.offsetMode==2
			data=data-minData;
			waveo(['ivLineFluorOffset' num2str(channel)], (offset-minData)*ones(1, size(data,1)));
			state.imageViewer.lineOffset(channel)=min(minData);
		elseif state.imageViewer.offsetMode==3
			waveo(['ivLineFluorOffset' num2str(channel)], offset*ones(1, size(data,1)));
			state.imageViewer.lineOffset(channel)=0;
		end	
		state.imageViewer.lineData(channel, :)=data;
		waveo(['ivLineFluor' num2str(channel)], data);
	end

	for channel=find(state.imageViewer.channelsOn)
		state.imageViewer.lineMin(channel)=min(state.imageViewer.lineData(channel, :));
		state.imageViewer.lineMax(channel)=max(state.imageViewer.lineData(channel, :));
		state.imageViewer.lineAvg(channel)=mean(state.imageViewer.lineData(channel, :));
		[pd, py]=findpeaks_small(state.imageViewer.lineData(channel, :), 1, 0, state.imageViewer.widthFraction);
		waveo(['ivLineFluorWidthX' num2str(channel)], pd-1);
		waveo(['ivLineFluorWidthY' num2str(channel)], py);
		state.imageViewer.lineHW(channel)=abs(pd(2)-pd(1));
		if channel==state.imageViewer.hwChannel
			pdKeep=round(pd);	
		end
	end
		
	for channel=find(state.imageViewer.channelsOn)
		state.imageViewer.lineHWAvg(channel)=mean(state.imageViewer.lineData(channel, pdKeep(1):pdKeep(2)));
	end

	if ~isempty(state.imageViewer.excelChannel)
		data=zeros(1, 10+size(find(state.imageViewer.channelsOn), 2)*8);
        data(1)=state.imageViewer.hwChannel;
        data(2)=state.imageViewer.selectionChannel;
        data(3)=state.imageViewer.offsetMode;
        data(4)=state.imageViewer.smoothingWidth;
        data(5)=state.imageViewer.widthFraction;
		ch=0;
		for channel=find(state.imageViewer.channelsOn)
			data(ch*8+7)=channel;
			data(ch*8+8)=state.imageViewer.lineOffset(channel);
			data(ch*8+9)=state.imageViewer.lineMin(channel);
			data(ch*8+10)=state.imageViewer.lineMax(channel);
			data(ch*8+11)=state.imageViewer.lineHW(channel);
			data(ch*8+12)=state.imageViewer.lineAvg(channel);
			data(ch*8+13)=state.imageViewer.lineHWAvg(channel);
			ch=ch+1;
		end
		
	end
	ivWriteToExcel(1, 1, data);