function waveList=ivTimeAnalysisToWaves(timePoints)
	global state

	if nargin<1
		timePoints=state.imageViewer.tsFileCounter;
	end
	
	if isempty(timePoints)
		timePoints=1:state.imageViewer.tsNumberOfFiles;
	end

	objects=1:size(state.imageViewer.objStructs,2);
	
	waveList=cell(0,0);
	
	nObjects=size(state.imageViewer.objStructs,2);
	
	waveo('tp_times', state.imageViewer.tsTimeStamp-state.imageViewer.tsTimeStamp(1));

	for timePoint=timePoints
		tpString = num2str(timePoint);
		disp(['Time point #' tpString]);
		length=zeros(1, nObjects);
		width=zeros(1, nObjects);
		peak=zeros(1, nObjects);
		area=zeros(1, nObjects);
		status=zeros(1, nObjects);
		lwRatio=zeros(1, nObjects);
		
		for objectNumber=1:nObjects
			status(objectNumber) = state.imageViewer.objStructs(objectNumber).status(timePoint);
			length(objectNumber) = state.imageViewer.objStructs(objectNumber).length(timePoint);
			width(objectNumber) = state.imageViewer.objStructs(objectNumber).width(timePoint);
			peak(objectNumber) = state.imageViewer.objStructs(objectNumber).max(timePoint);
			area(objectNumber) = state.imageViewer.objStructs(objectNumber).area(timePoint);
			if length(objectNumber)~=0 & width(objectNumber)~=0
				lwRatio(objectNumber)=length(objectNumber)/width(objectNumber);
			else
				lwRatio(objectNumber)=0;
			end
		end
		

		
		
		%calculate spine density for each timepoint by counting all spines not marked 'gone'
		spines = sum(status ~= 3);  																%Changed    
		if state.imageViewer.tsDendriteLength(timePoint) > 0
			density = spines/state.imageViewer.tsDendriteLength(timePoint); 
		else
			density = 0
		end
		
		waveo(['tp' tpString '_denLength'], state.imageViewer.tsDendriteLength(timePoint)); 				 %Changed
		waveo(['tp' tpString '_density'], density);    											     %Changed
		waveo(['tp' tpString '_length'], length);
		waveo(['tp' tpString '_width'], width);
		waveo(['tp' tpString '_peak'], peak);
		waveo(['tp' tpString '_area'], area);
		waveo(['tp' tpString '_status'], status);
		waveo(['tp' tpString '_lwRatio'], lwRatio);
		
		waveList(end+1:end+8) = {...
			['tp' tpString '_length'], ...
			['tp' tpString '_width'], ...
			['tp' tpString '_peak'], ...
			['tp' tpString '_area'], ...
			['tp' tpString '_status'], ...
			['tp' tpString '_denLength'],... 				 %Changed
			['tp' tpString '_density']... 	%Changed
			['tp' tpString '_lwRatio']...
		};
	
		
		if state.imageViewer.analyzeLines | state.imageViewer.analyzeBoxes
			% assume that all objects have the same channels analyzed as object 1
			% and cycle through them
			for channelCounter=1:size(state.imageViewer.objStructs(1).results(timePoint).analysisChannel, 2)
				channelCode=state.imageViewer.objStructs(1).results(timePoint).analysisChannel(channelCounter);
				
				if channelCode~=0
					if channelCode<0
						channelString=['p' num2str(-channelCode)];
					else
						channelString=num2str(channelCode);
					end
					if state.imageViewer.objStructs(objectNumber).results(1).isBox(channelCounter)
						channelString=['b' channelString];
					end
					
					maxData=zeros(1, nObjects);
					sizeData=zeros(1, nObjects);
					avgData=zeros(1, nObjects);
					maskMaxData=zeros(1, nObjects);
					maskAvgData=zeros(1, nObjects);
					maskSizeData=zeros(1, nObjects);
	
					for objectNumber=1:nObjects
						maxData(objectNumber) = state.imageViewer.objStructs(objectNumber).results(timePoint).max(channelCounter);
						avgData(objectNumber) = state.imageViewer.objStructs(objectNumber).results(timePoint).avg(channelCounter);
						sizeData(objectNumber) = state.imageViewer.objStructs(objectNumber).results(timePoint).size(channelCounter);
						maskMaxData(objectNumber) = state.imageViewer.objStructs(objectNumber).results(timePoint).maskMax(channelCounter);
						maskAvgData(objectNumber) = state.imageViewer.objStructs(objectNumber).results(timePoint).maskAvg(channelCounter);
						maskSizeData(objectNumber) = state.imageViewer.objStructs(objectNumber).results(timePoint).maskSize(channelCounter);
					end
	
					waveo(['tp' tpString '_c' channelString '_max'], maxData);
					waveo(['tp' tpString '_c' channelString '_size'], sizeData);
					waveo(['tp' tpString '_c' channelString '_avg'], avgData);
					waveo(['tp' tpString '_c' channelString '_maskMax'], maskMaxData);
					waveo(['tp' tpString '_c' channelString '_maskAvg'], maskAvgData);
					waveo(['tp' tpString '_c' channelString '_maskSize'], maskSizeData);
					waveList(end+1:end+6) = {...
							['tp' tpString '_c' channelString '_max'], ...
							['tp' tpString '_c' channelString '_size'], ...
							['tp' tpString '_c' channelString '_avg'], ...
							['tp' tpString '_c' channelString '_maskMax'], ...
							['tp' tpString '_c' channelString '_maskAvg'], ...
							['tp' tpString '_c' channelString '_maskSize'], ...
						};
				end
			end
		end
	end
			