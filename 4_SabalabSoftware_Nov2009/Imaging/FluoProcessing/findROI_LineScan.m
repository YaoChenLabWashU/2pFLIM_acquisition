function [outx, outy]=findROI_LineScan(lineData, numROI, width, offset, minPeak, minDip)
% find ROIs in lineData scanes 
% pass in number of ROIs, min value to be considered a peak or a dip
	
	if nargin<3
		width=0.3;
	end
	if nargin<4
		offset=0;
	end
	if nargin<5
		minPeak=offset;
	end
	if nargin<6
		minDip=offset;
	end
	
	[peaksDetected, dipsDetected]=peakdetect(lineData);
	
	[peaks, peaksIndex]=sort(lineData(peaksDetected));
	above=find(peaks>minPeak);
	peaksIndex=peaksDetected(peaksIndex(above));
	
	if length(above)<numROI
		clear peaks peaksIndex above peaksDetected
		error('findROI_LineScan: Insufficient peaks to detect ROIs');
	end
	
	if length(peaks)>numROI
		peaks=peaks(end-numROI+1:end);
		peaksIndex=peaksIndex(end-numROI+1:end);
	end

	peaksIndex=sort(peaksIndex);
	peaks=lineData(peaksIndex);
	
	[dips, dipsIndex]=sort(lineData(dipsDetected));
	above=find(dips>minDip);

	dipsIndex=dipsDetected(dipsIndex(above));
	dipsIndex=sort(dipsIndex);
	dips=lineData(dipsIndex);
	
	
	clear above peaksDetected dipsDetected
	
	[merged, type, index]=mergesort(peaksIndex, dipsIndex);
	
	dipCounter=1;
	peakCounter=1;
	done=0;
	
	outx=zeros(numROI, 2);
	outy=zeros(numROI, 2);
	lastDip=0;
	
	mergedCounter=1;
	while peakCounter<=numROI
		if type(mergedCounter)==2
			lastDip=merged(mergedCounter);
			mergedCounter=mergedCounter+1;
		else
			thresh=offset+width*(lineData(peaksIndex(index(mergedCounter)))-offset);
			extent=lineData>thresh;

			[leftEdge, rightEdge]=contiguousRange(peaksIndex(index(mergedCounter)), extent);
			if peakCounter~=1
				leftEdge=max(lastDip,leftEdge);
			end
			
			if peakCounter~=numROI & mergedCounter<length(merged)
				rightEdge=min(rightEdge, merged(mergedCounter+1));
			end
			outx(peakCounter, :)=[leftEdge rightEdge];
			outy(peakCounter, :)=lineData(outx(peakCounter, :));
			
			peakCounter=peakCounter+1;
			mergedCounter=mergedCounter+1;
		end
	end
	
		
		