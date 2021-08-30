function ivFlipTimeSeries(fileCounter, force)
	global state
	
	if nargin<2
		force=0;
	end
	
	if nargin<1
		fileCounter=state.imageViewer.tsFileCounter;
	end
	
	
	fileCounter=max(min(fileCounter, length(state.imageViewer.tsFileNames)), 1);
	if (state.imageViewer.tsFileCounter==fileCounter) & ~force
		return
	end

	state.imageViewer.tsFileCounter=fileCounter;
	updateGUIByGlobal('state.imageViewer.tsFileCounter');
    try
    	state.imageViewer.epoch = valueFromHeaderString('state.epoch', state.imageViewer.tsStackHeader{fileCounter});
    catch
        state.imageViewer.epoch=0;
    end
	updateGUIByGlobal('state.imageViewer.epoch');
	
	try
		state.imageViewer.triggerTime=state.imageViewer.tsTimeStamp(fileCounter);
	catch
		state.imageViewer.triggerTime=0;
	end
	updateGUIByGlobal('state.imageViewer.triggerTime');
	
%	state.imageViewer.stackData=state.imageViewer.tsCoredStackData(fileCounter, :)';
%	state.imageViewer.projectionData=state.imageViewer.tsCoredFlatProjection(fileCounter, :)';
%	state.imageViewer.projectionIndexData=state.imageViewer.tsCoredFlatProjectionIndex(fileCounter, :)';

	state.imageViewer.pixelShiftX=state.imageViewer.tsShift(fileCounter, 1);
	state.imageViewer.pixelShiftY=state.imageViewer.tsShift(fileCounter, 2);
	state.imageViewer.pixelShiftZ=state.imageViewer.tsShift(fileCounter, 3);	
	state.imageViewer.currentDendriteLength=state.imageViewer.tsDendriteLength(fileCounter);
	updateGUIByGlobal('state.imageViewer.currentDendriteLength')
	
	updateGUIByGlobal('state.imageViewer.pixelShiftX');
	updateGUIByGlobal('state.imageViewer.pixelShiftY');
	updateGUIByGlobal('state.imageViewer.pixelShiftZ');

	state.imageViewer.fileName=state.imageViewer.tsFileNames{fileCounter};
	updateGUIByGlobal('state.imageViewer.fileName');

	channelList=find(state.imageViewer.dataChannels(1:14).*...
		(state.imageViewer.anaChannels(1:14)+state.imageViewer.anaMaxChannels(1:14)).*...
		state.imageViewer.viewChannels(1:14));
	state.imageViewer.nSlices=size(state.imageViewer.tsCoredStackData{fileCounter, channelList(1)},3);
	state.imageViewer.nPixelsY=size(state.imageViewer.tsCoredStackData{fileCounter, channelList(1)},1);
	state.imageViewer.nPixelsX=size(state.imageViewer.tsCoredStackData{fileCounter, channelList(1)},2);
	updateGUIByGlobal('state.imageViewer.nSlices');
	updateGUIByGlobal('state.imageViewer.nPixelsY');
	updateGUIByGlobal('state.imageViewer.nPixelsX');
	
	ivUpdateFigures;
	ivUpdateProjFigures;

	if state.imageViewer.objectShowTraces
		ivMakeObjectVisible	
	end
	
	for channel=channelList
		set(state.imageViewer.figure(channel), 'Name',  ['Acquisition of Channel ' num2str(channel) ' TS #' num2str(fileCounter)]);
		set(state.imageViewer.projFigure(channel), 'Name',  ['Projection of Channel ' num2str(channel) ' TS #' num2str(fileCounter)]);
	end
