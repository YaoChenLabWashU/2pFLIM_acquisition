function ivLoadData
	global state
	
	success=ivLoadInformation(state.imageViewer.currentDataFields);
% 	if success
% 		return
% 	end

	ivDeleteAllHandles([]);
	ivClearAxisHandles;
	for objectNumber=1:size(state.imageViewer.objStructs, 2)
		state.imageViewer.objStructs(objectNumber).boundBoxHandle=[];
		state.imageViewer.objStructs(objectNumber).boundBoxLabelHandle=[];
		state.imageViewer.objStructs(objectNumber).axisLineHandle1=[];
		state.imageViewer.objStructs(objectNumber).axisLineHandle2=[];
		state.imageViewer.objStructs(objectNumber).boxHandle=[];
	end
	if size(state.imageViewer.objStructs, 2)>=1
		if ~isfield(state.imageViewer.objStructs(1), 'text')
			state.imageViewer.objStructs(end).text='';
		end
	end

	trackMode=state.imageViewer.trackMode;
	state.imageViewer.trackMode=1;
	updateGUIByGlobal('state.imageViewer.trackMode');
	state.imageViewer.tsNumberOfFiles=size(state.imageViewer.tsFileNames, 2);
	if length(state.imageViewer.tsDendriteLength)~=state.imageViewer.tsNumberOfFiles
		state.imageViewer.tsDendriteLength=zeros(1, state.imageViewer.tsNumberOfFiles);
	end
	ivLoadTimeSeries(2);
    return
	state.imageViewer.trackMode=trackMode;
	updateGUIByGlobal('state.imageViewer.trackMode');

	ivApplyTimeSeriesShifts;
	ivFlipTimeSeries(1);
	ivDrawObjectBound([]);
	ivMakeObjectVisible([], 1);
		
		
