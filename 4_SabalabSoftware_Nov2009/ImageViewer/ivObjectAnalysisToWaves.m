function waveList=ivObjectAnalysisToWaves(objects, generic)
	global state
	
	if nargin<2
		generic=1;
	end
	
	if nargin<1
		objects=state.imageViewer.currentObject;
	end

	if isempty(objects)
		objects=1:size(state.imageViewer.objStructs,2);
	end
	
	waveList=cell(0,0);
	
	for objectNumber=objects
		objectNumString=num2str(objectNumber);
		disp(['Object #' objectNumString]);
		if generic
			waveo('objectLengthWave', state.imageViewer.objStructs(objectNumber).length);
		 	waveo('objectWidthWave', state.imageViewer.objStructs(objectNumber).width);
		 	waveo('objectAreaWave', state.imageViewer.objStructs(objectNumber).area);
		 	waveo('objectPeakWave', state.imageViewer.objStructs(objectNumber).max);
		 	waveo('objectSliceWave', state.imageViewer.objStructs(objectNumber).analysisSlice);
			waveo('objectTimeWave', state.imageViewer.tsTimeStamp-state.imageViewer.tsTimeStamp(1));
			waveo('objectStatusWave', state.imageViewer.objStructs(objectNumber).status);
			waveList(end+1:end+7)={'objectLengthWave', 'objectWidthWave', 'objectAreaWave', ...
					'objectPeakWave', 'objectSliceWave', 'objectTimeWave', 'objectStatusWave'};
		else
			waveo(['o' objectNumString '_length'], state.imageViewer.objStructs(objectNumber).length);
         	waveo(['o' objectNumString '_width'], state.imageViewer.objStructs(objectNumber).width);
         	waveo(['o' objectNumString '_area'], state.imageViewer.objStructs(objectNumber).area);
         	waveo(['o' objectNumString '_peak'], state.imageViewer.objStructs(objectNumber).max);
         	waveo(['o' objectNumString '_slice'], state.imageViewer.objStructs(objectNumber).analysisSlice);
         	waveo(['o' objectNumString '_time'], state.imageViewer.tsTimeStamp-state.imageViewer.tsTimeStamp(1));
			waveo(['o' objectNumString '_status'], state.imageViewer.objStructs(objectNumber).status);
			waveList(end+1:end+7)={['o' objectNumString '_length'], ...
					['o' objectNumString '_width'], ...
					['o' objectNumString '_area'], ...
					['o' objectNumString '_peak'], ...
					['o' objectNumString '_slice'], ...
					['o' objectNumString '_time'], ...
					['o' objectNumString '_status']...
				};
		end
			
		nPoints=length(state.imageViewer.objStructs(objectNumber).results);
		if nPoints>0
			for channelCounter=1:length(state.imageViewer.objStructs(objectNumber).results(1).analysisChannel)
				channelCode=state.imageViewer.objStructs(objectNumber).results(1).analysisChannel(channelCounter);
				if channelCode~=0
					if channelCode<0
						channelString=['p' num2str(-channelCode)];
					else
						channelString=num2str(channelCode);
					end
					if state.imageViewer.objStructs(objectNumber).results(1).isBox(channelCounter)
						channelString=['b' channelString];
					end
				
					maxData=zeros(1, nPoints);
					avgData=zeros(1, nPoints);
					sizeData=zeros(1, nPoints);
					maskMaxData=zeros(1, nPoints);
					maskAvgData=zeros(1, nPoints);
					maskSizeData=zeros(1, nPoints);
				
					for timePoint=1:nPoints
						maxData(timePoint) = state.imageViewer.objStructs(objectNumber).results(timePoint).max(channelCounter);
						avgData(timePoint) = state.imageViewer.objStructs(objectNumber).results(timePoint).avg(channelCounter);
						sizeData(timePoint) = state.imageViewer.objStructs(objectNumber).results(timePoint).size(channelCounter);
						maskMaxData(timePoint) = state.imageViewer.objStructs(objectNumber).results(timePoint).maskMax(channelCounter);
						maskAvgData(timePoint) = state.imageViewer.objStructs(objectNumber).results(timePoint).maskAvg(channelCounter);
						maskSizeData(timePoint) = state.imageViewer.objStructs(objectNumber).results(timePoint).maskSize(channelCounter);
					end
					if generic 
						objectNumString='';
					end
					waveo(['o' objectNumString '_c' channelString '_max'], maxData);
					waveo(['o' objectNumString '_c' channelString '_size'], sizeData);
					waveo(['o' objectNumString '_c' channelString '_avg'], avgData);
					waveo(['o' objectNumString '_c' channelString '_maskMax'], maskMaxData);
					waveo(['o' objectNumString '_c' channelString '_maskAvg'], maskAvgData);
					waveo(['o' objectNumString '_c' channelString '_maskSize'], maskSizeData);
					waveList(end+1:end+6) = {...
							['o' objectNumString '_c' channelString '_max'], ...
							['o' objectNumString '_c' channelString '_size'], ...
							['o' objectNumString '_c' channelString '_avg'], ...
							['o' objectNumString '_c' channelString '_maskMax'], ...
							['o' objectNumString '_c' channelString '_maskAvg'], ...
							['o' objectNumString '_c' channelString '_maskSize'], ...
						}
				end
			end
		end
	end
