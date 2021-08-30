function out=ROIScanName(channel, roi, acq)
	if nargin==2
		out=['c' num2str(channel) 'r' num2str(roi)];
	elseif nargin==3
		out=['c' num2str(channel) 'r' num2str(roi) '_' num2str(acq)];
	else
		out=[];
		error('ROISCanName: wrong nmber of inputs');
	end