function [moment, rTotal, rMinor, rMajor]=ivMomentOfInertia(im, xCm, yCm, mass, lineAngle)
	if nargin<5
		[xCm, yCm, mass, peakVal, pixSize, lineParam]=ivCenterOfMass(im);
		lineAngle=180*atan2(lineParam(1), 1)/pi;
	end
	
	xd=size(im, 2);
	yd=size(im, 1);
	
	xInd=repmat(([1:xd]-xCm).^2, yd, 1);
	yInd=repmat([([1:yd]-yCm).^2]', 1, xd);

	moment=sum(sum(im.*(xInd+yInd)));
	rTotal=sqrt(moment/mass);
	
	xInd=repmat(([1:xd]-xCm), yd, 1);
	yInd=repmat([([1:yd]-yCm)]', 1, xd);

	xIndRot=cos(lineAngle*pi/180)*xInd + sin(lineAngle*pi/180)*yInd;
	yIndRot=-sin(lineAngle*pi/180)*xInd + cos(lineAngle*pi/180)*yInd;
	
	rMinor=sqrt(sum(sum(im.*yIndRot.^2))/mass);
	rMajor=sqrt(sum(sum(im.*xIndRot.^2))/mass);
	