function out=FWHM(data, offset)
	if nargin==1
		offset=min(data);
	end
	waveo('FWHMdata', data);
    % gy fixed the case to findPeaks 201204 for R2012a
    %   assuming that this is the FluoProcessing\findPeaks
    %   and not the built-in findpeaks
	[pd, py]=findPeaks(data, 1, offset, 0.3);
	waveo('FWHMx', pd-1);
	waveo('FWHMy', py);
	out=pd(2)-pd(1);
	