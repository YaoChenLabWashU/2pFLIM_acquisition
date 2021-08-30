function ivAnalyzeFluor(x, y)
	global state

	ivBringSelectionToFront;	
	if nargin<2
		[x,y]=ginput(2);
		if size(x,1)~=2
			return
		end
	end
	
	axisHandle=gca;
	
	x=round(x);
	y=round(y);
	
	if state.imageViewer.analyzeBox
		x=sort(x);
		y=sort(y);
	end

	if state.imageViewer.storeSelections 
		if nargin<2
			state.imageViewer.definedLines(end+1, :)=[x' y'];	
			counter=length(state.imageViewer.lineHandles);
			x=x-state.imageViewer.pixelShiftX;
			y=y-state.imageViewer.pixelShiftY;
			if state.imageViewer.analyzeBox
				x2=[x(1) x(2) x(2) x(1) x(1)]';
				y2=[y(1) y(1) y(2) y(2) y(1)]';
				state.imageViewer.lineHandles(counter+1) = line(x2+state.imageViewer.pixelShiftX, y2+state.imageViewer.pixelShiftY, ...
					'tag', ['sel ' num2str(counter)], 'color', 'b', ...
					'linewidth', 1, 'Parent', axisHandle);
				state.imageViewer.lineHandlesRef(counter+1) = line(x2, y2, ...
					'tag', ['sel ' num2str(counter)], 'color', 'b', ...
					'linewidth', 1, 'Parent', state.imageViewer.referenceAxis);
			else
				state.imageViewer.lineHandles(counter+1) = line(x+state.imageViewer.pixelShiftX, y+state.imageViewer.pixelShiftY,...
					'tag', ['sel ' num2str(counter)], 'color', 'b', ...
					'linewidth', 1, 'Parent', axisHandle);
				state.imageViewer.lineHandlesRef(counter+1) = line(x, y, ...
					'tag', ['sel ' num2str(counter)], 'color', 'b', ...
					'linewidth', 1, 'Parent', state.imageViewer.referenceAxis);
			end
			state.imageViewer.currentSelection=counter+1;
			updateGUIByGlobal('state.imageViewer.currentSelection');
		end
		ivUpdateSelectionDisplay;
		ivUpdateSelCoords;
	else
		state.imageViewer.currentSelection=0;
		updateGUIByGlobal('state.imageViewer.currentSelection');
		ivUpdateSelCoords;
	end
	x=x+state.imageViewer.pixelShiftX;
	y=y+state.imageViewer.pixelShiftY;
	
	
	channelsToAnalyze=[...
			state.imageViewer.anaChannel1, ...
			state.imageViewer.anaChannel2, ...
			state.imageViewer.anaChannel3, ...
			state.imageViewer.anaChannel4, ...
			state.imageViewer.anaProjection1, ...
			state.imageViewer.anaProjection2, ...
			state.imageViewer.anaProjection3, ...
			state.imageViewer.anaProjection4 ...
			0 ...
			0 ...
			state.imageViewer.anaChannel11, ...
			state.imageViewer.anaChannel12, ...
			state.imageViewer.anaChannel13, ...
			state.imageViewer.anaChannel14, ...
			state.imageViewer.anaProjection11, ...
			state.imageViewer.anaProjection12, ...
			state.imageViewer.anaProjection13, ...
			state.imageViewer.anaProjection14 ...
		];
			
	nChan=length(find(channelsToAnalyze));

	state.imageViewer.anaData={};
	state.imageViewer.anaMask={};
	state.imageViewer.anaChannel=zeros(1,nChan);
	state.imageViewer.anaMin=zeros(1,nChan);
	state.imageViewer.anaMax=zeros(1,nChan);
	state.imageViewer.anaMaskPixels=zeros(1,nChan);
	state.imageViewer.anaMaskAvg=zeros(1,nChan);
	state.imageViewer.anaAvg=zeros(1,nChan);
	state.imageViewer.anaOffset=zeros(1,nChan);
	
	indexCounter=1;
	for channel=find(channelsToAnalyze)
		if state.imageViewer.analyzeBox
			if (channel>=1 & channel<=4) | (channel>=11 & channel<=14)
				data=double(state.imageViewer.stackData{channel}(y(1):y(2), x(1):x(2), state.imageViewer.displayedSlice));
			else 
				data=double(state.imageViewer.projectionData{channel-4}(y(1):y(2), x(1):x(2)));
			end
			if state.imageViewer.smoothingWidth>1
				ker=ones(state.imageViewer.smoothingWidth, state.imageViewer.smoothingWidth)/(state.imageViewer.smoothingWidth^2);
				data=imfilter(data, ker, 'replicate');
			end
		else
			if (channel>=1 & channel<=4) | (channel>=11 & channel<=14)
				data=improfile(state.imageViewer.stackData{channel}(:,:,state.imageViewer.displayedSlice), x, y);	
			else
				data=improfile(state.imageViewer.projectionData{channel-4}(:,:), x, y);	
			end
			
			if state.imageViewer.smoothingWidth>1
				data=smooth(data', state.imageViewer.smoothingWidth)';
			end
		end

		if (channel>=1 & channel<=4) | (channel>=11 & channel<=14)
			offset=getfield(state.imageViewer, ['offsetChannel' num2str(channel)]);
		else
			offset=getfield(state.imageViewer, ['offsetChannel' num2str(channel-4)]);
		end
		
		if state.imageViewer.offsetMode==1
			subVal=offset;
		elseif state.imageViewer.offsetMode==2
			subVal=min(data);
			if state.imageViewer.analyzeBox
				subVal=min(subVal);
			end
		elseif state.imageViewer.offsetMode==3
			subVal=0;
		end	
		data=data-subVal;
		
		waveo(['ivLineFluorOffset' num2str(channel)], (offset-subVal)*ones(1, size(data,1)));
		state.imageViewer.anaOffset(indexCounter)=subVal;
		state.imageViewer.anaData{indexCounter}=data;

		if state.imageViewer.analyzeBox
			waveo(['ivBoxFluor' num2str(channel)], data);
		else
			waveo(['ivLineFluor' num2str(channel)], data);
		end
		state.imageViewer.anaChannel(indexCounter)=channel;
		indexCounter=indexCounter+1;
	end

	for indexCounter=1:nChan
		channel=state.imageViewer.anaChannel(indexCounter);
		if state.imageViewer.analyzeBox
			state.imageViewer.anaMin(indexCounter)=min(min(state.imageViewer.anaData{indexCounter}));
			if state.imageViewer.numTopPixels>1
				data2=sort(reshape(state.imageViewer.anaData{indexCounter}, 1, []));
				peakVal=mean(data2(end-state.imageViewer.numTopPixels+1:end));
			else
				peakVal=max(max(state.imageViewer.anaData{indexCounter}));
			end
			state.imageViewer.anaMax(indexCounter)=peakVal;
			state.imageViewer.anaAvg(indexCounter)=mean2(state.imageViewer.anaData{indexCounter});
			thresh=state.imageViewer.anaMax(indexCounter)*state.imageViewer.widthFraction;
			state.imageViewer.anaMask{indexCounter}=double(state.imageViewer.anaData{indexCounter}>=thresh);
			waveo(['ivBoxMask' num2str(channel)], state.imageViewer.anaMask{indexCounter});
			truePix=find(state.imageViewer.anaMask{indexCounter});
     		state.imageViewer.anaMaskPixels(indexCounter)=length(truePix);
			if channel==state.imageViewer.hwChannel
				mask=state.imageViewer.anaMask{indexCounter};
				maskPixels=state.imageViewer.anaMaskPixels(indexCounter);
				waveo('ivBoxMask', state.imageViewer.anaMask{indexCounter});
				waveo('ivBoxFluor', state.imageViewer.anaData{indexCounter});				
			end
		else		
			state.imageViewer.anaMin(indexCounter)=min(state.imageViewer.anaData{indexCounter});
			state.imageViewer.anaMax(indexCounter)=max(state.imageViewer.anaData{indexCounter});
			state.imageViewer.anaAvg(indexCounter)=mean(state.imageViewer.anaData{indexCounter});
			thresh=state.imageViewer.anaMax(indexCounter)*state.imageViewer.widthFraction;
			state.imageViewer.anaMask{indexCounter}=state.imageViewer.anaData{indexCounter}>=thresh;
			truePix=find(state.imageViewer.anaMask{indexCounter});
			temp(1:length(data))=nan;
			temp(find(state.imageViewer.anaMask{indexCounter}))=thresh;
     		waveo(['ivLineFluorWidth' num2str(channel)], temp);
     		state.imageViewer.anaMaskPixels(indexCounter)=length(find(state.imageViewer.anaMask{indexCounter}));
			if channel==state.imageViewer.hwChannel
				mask=state.imageViewer.anaMask{indexCounter};
				maskPixels=length(find(mask));
			end
		end
	end

	for indexCounter=1:nChan
		state.imageViewer.anaMaskAvg(indexCounter)=mean(state.imageViewer.anaData{indexCounter}(find(mask)));
	end

	if state.imageViewer.autoWriteToExcel
		channelNames={...
				'Chan 1', ...
				'Chan 2', ...
				'Chan 3', ...
				'Chan 4', ...
				'Proj 1', ...
				'Proj 2', ...		
				'Proj 3', ...
				'Proj 4', ...
				'error', ...
				'error', ...
				'Chan 11', ...
				'Chan 12', ...
				'Chan 13', ...
				'Chan 14', ...
				'Proj 11', ...
				'Proj 12', ...		
				'Proj 13', ...
				'Proj 14', ...
			};
		offsetModes={'sub pmt', 'sub local', 'none'};
	
		ivWriteToExcel(1, 0);
		ivWriteToExcel(0, 0, ' ');
		
		if ~isempty(state.imageViewer.excelChannel)
			ivWriteToExcel(0, 0, channelNames{state.imageViewer.selectionChannel});
			ivWriteToExcel(0, 0, channelNames{state.imageViewer.hwChannel});
     		ivWriteToExcel(0, 0, offsetModes{state.imageViewer.offsetMode});
     		ivWriteToExcel(0, 0, state.imageViewer.smoothingWidth);
      		ivWriteToExcel(0, 0, state.imageViewer.widthFraction);
			ivWriteToExcel(0, 0, state.imageViewer.currentSelection);
      		ivWriteToExcel(0, 0, [x(1) y(1)]);
      		ivWriteToExcel(0, 0, [x(2) y(2)]);
			ivWriteToExcel(0, 0, maskPixels);
			
			ivWriteToExcel(0, 0, ' ');
	
     		for indexCounter=1:nChan
     			ivWriteToExcel(0, 0, channelNames{state.imageViewer.anaChannel(indexCounter)});
      			ivWriteToExcel(0, 0, state.imageViewer.anaOffset(indexCounter));
      			ivWriteToExcel(0, 0, state.imageViewer.anaMin(indexCounter));
      			ivWriteToExcel(0, 0, state.imageViewer.anaMax(indexCounter));
      			ivWriteToExcel(0, 0, state.imageViewer.anaAvg(indexCounter));
      			ivWriteToExcel(0, 0, state.imageViewer.anaMaskPixels(indexCounter));
      			ivWriteToExcel(0, 0, state.imageViewer.anaMaskAvg(indexCounter));
      			ivWriteToExcel(0, 0, ' ');
			end
		end
		ivWriteToExcel(0,1,' ');
	end
	