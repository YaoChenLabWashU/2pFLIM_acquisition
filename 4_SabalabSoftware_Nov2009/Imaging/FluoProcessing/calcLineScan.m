function out=calcLineScan(im, startLine, stopLine, filterPoint)
	if nargin<4
		filterPoint=3;
	end
	if nargin<3
		stopLine=size(im, 1);
	end
	if nargin<2
		startLine=1;
	end
	
	if stopLine<1 | stopLine>size(im,1)
		stopLine=size(im, 1);
	end		
	if startLine<1
		startLine=1;
	end		
	
	out=mean(im(startLine:stopLine,:),1);
	if filterPoint>1
		out=filter(repmat(1/filterPoint, 1, filterPoint), 1, out);
	end