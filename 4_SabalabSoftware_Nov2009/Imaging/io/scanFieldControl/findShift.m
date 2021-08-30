function corr=findshift(im1, im2)
	
	cc = normxcorr2(im1,im2);
	[max_cc, imax] = max(abs(cc(:)));
	[ypeak, xpeak] = ind2sub(size(cc),imax(1));
	corr= [ (ypeak-size(im1,1)) (xpeak-size(im1,2)) max_cc];