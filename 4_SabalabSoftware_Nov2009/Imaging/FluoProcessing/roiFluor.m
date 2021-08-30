function out=roiFluor(imData, roiDefs, offset)
	
	global state
	if state.analysis.analysisMode==2 | (state.analysis.analysisMode==4 & state.acq.lineScan)	% line scan analysis
		out=zeros(size(roiDefs,1), size(imData,1));
	
		for counter=1:size(roiDefs,1)
			out(counter, :)=mean(imData(:,roiDefs(counter,1):roiDefs(counter,2)),2)'-offset;
		end
	elseif state.analysis.analysisMode==3 | (state.analysis.analysisMode==4 & ~state.acq.lineScan) % 2d analysis
		out=zeros(size(roiDefs,1), size(imData,3));
	
		for counter=1:size(roiDefs,1)
			out(counter, :)=mean(mean(imData(roiDefs(counter,3):roiDefs(counter,4), roiDefs(counter,1):roiDefs(counter,2), :), 1), 2) - offset;
		end
	end
		
