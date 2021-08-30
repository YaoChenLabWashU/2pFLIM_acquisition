function out=ROIAvgScanName(epoch, pulse, channel, roi)
	
	if nargin==4
		out=['e' num2str(epoch) 'p' num2str(pulse) 'c' num2str(channel) 'r' num2str(roi) '_avg'];
	else
		out=[];
		error('ROISCanName: wrong nmber of inputs');
	end