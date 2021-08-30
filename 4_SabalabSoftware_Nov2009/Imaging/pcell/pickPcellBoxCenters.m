function pickPcellBoxCenters(invert)
	if nargin<1
		invert=0;
	end
	
	global state 
     pixWidth=state.pcell.boxSize; % default is 10 
%      pixWidth=10;     % 6

	setStatusString('Click spines');
	siSelectionChannelToFront
	
	try
		[xc,yc]=ginput;
		xc=round(xc);
		yc=round(yc);
		
		if length(xc)<1
			return
		end
		
		state.pcell.boxNumber=1;
		settingsManager('recall', 'pcellBox', state.pcell.boxNumber);
		updateGUIByGlobal('state.pcell.boxNumber');

		laserPower1=state.pcell.boxPowerLevel1;
		laserPower2=state.pcell.boxPowerLevel2;
		
		disp([num2str(length(xc)) ' box centers picked'])
		disp(['Using box size state.pcell.boxSize = ' num2str(pixWidth)]);
		
		for counter=1:length(xc)
			state.pcell.boxNumber=counter;
			updateGUIByGlobal('state.pcell.boxNumber');
			x=[max(xc(state.pcell.boxNumber)-pixWidth,1) min(xc(state.pcell.boxNumber)+pixWidth, state.acq.pixelsPerLine)]; 		
            y=[max(yc(state.pcell.boxNumber)-pixWidth,1) min(yc(state.pcell.boxNumber)+pixWidth, state.acq.linesPerFrame)];
				
			state.pcell.boxPowerLevel1=laserPower1;
			state.pcell.boxPowerLevel2=laserPower2;
			state.pcell.boxActiveStatus=1;
			state.pcell.boxFrameNumber=1;
	
			[maxImage, maxIndex]=extractMaxFromStack(state.internal.selectionChannel, x, y);
			if ~invert
				state.pcell.boxSliceNumber=mode(maxIndex);
			else
				state.pcell.boxSliceNumber=0+state.acq.numberOfZSlices-mode(maxIndex)+ state.internal.blastSliceOffset; %default Offset is 0
				disp(['state.pcell.boxSliceNumber= ' num2str(state.pcell.boxSliceNumber)]);
			end
			disp([counter state.pcell.boxSliceNumber]);
			updateGUIByGlobal('state.pcell.boxSliceNumber');
			
			state.pcell.boxStartX=x(1);
			state.pcell.boxStartY=y(1);
			state.pcell.boxEndX=x(2);
			state.pcell.boxEndY=y(2);
		
			state.pcell.boxStartX
			settingsManager('store', 'pcellBox', state.pcell.boxNumber);
			settingsManager('extractval', 'pcellBox', state.pcell.boxNumber, 'state.pcell.boxStartX')
		end

		setLength=settingsManager('getsetlength', 'pcellBox');
		if length(xc)<setLength
			for counter=length(xc)+1:setLength
				state.pcell.boxActiveStatus=0;
				settingsManager('storeone', 'pcellBox', counter, 'state.pcell.boxActiveStatus');
			end
		end

		state.pcell.boxNumber=1;
		updateGUIByGlobal('state.pcell.boxNumber');
		settingsManager('recall', 'pcellBox', state.pcell.boxNumber);

		state.internal.needNewPcellPowerOutput=1;
		applyChangesToOutput;
		
		setStatusString('Done');
	catch
		disp(['*** pickPcellBoxCenters : ' lasterr])
		state.pcell.boxNumber=1;
		settingsManager('recall', 'pcellBox', state.pcell.boxNumber);
		setStatusString('Error');

	end
		