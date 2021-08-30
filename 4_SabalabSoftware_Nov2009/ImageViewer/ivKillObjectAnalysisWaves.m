function ivKillObjectAnalysisWaves(objects)
	global state
	
	if nargin<1
		objects=state.imageViewer.currentObject;
	end

	if isempty(objects)
		objects=1:size(state.imageViewer.objStructs,2);
	end
	
	for objectNumber=objects
		objectNumString=num2str(objectNumber);
		
		kill(['o' objectNumString '_length'], 'q');
       	kill(['o' objectNumString '_width'], 'q');
       	kill(['o' objectNumString '_area'], 'q');
       	kill(['o' objectNumString '_max'], 'q');

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
			
				kill(['o' objectNumString '_c' channelString '_max'], 'q');
				kill(['o' objectNumString '_c' channelString '_size'], 'q');
				kill(['o' objectNumString '_c' channelString '_avg'], 'q');
				kill(['o' objectNumString '_c' channelString '_maskMax'], 'q');
				kill(['o' objectNumString '_c' channelString '_maskAvg'], 'q');
				kill(['o' objectNumString '_c' channelString '_maskSize'], 'q');
			end
		end
	end
