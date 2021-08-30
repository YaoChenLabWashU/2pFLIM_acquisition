function [xCm, yCm, mass, peakVal, pixSize, lineParam]=ivCenterOfMass(im)

	xd=size(im, 2);
	yd=size(im, 1);
	
	xInd=repmat(1:xd, yd, 1);
	yInd=repmat([1:yd]', 1, xd);
	
	mass=sum(sum(im));
	
	xScaled=xInd.*im;
	xCm=sum(sum(xScaled))/mass;

	yScaled=yInd.*im;
	yCm=sum(sum(yScaled))/mass;
	
	peakIndX=[max(round(xCm)-1, 1) round(xCm) min(round(xCm)+1, xd)];
	peakIndY=[max(round(yCm)-1, 1) round(yCm) min(round(yCm)+1, yd)];
	
	sortIm=sort(reshape(-im, 1, xd*yd));
	peakVal=-mean(sortIm(1:4));  %mean(mean(im(peakIndX, peakIndY)))
	aboveThresh=find(im>peakVal*0.5);
	
	pixSize=length(aboveThresh);
	xAbove=xInd(aboveThresh)'-xCm;
	yAbove=yInd(aboveThresh)'-yCm;
	lineParam = polyfit(xAbove, yAbove, 1);
	