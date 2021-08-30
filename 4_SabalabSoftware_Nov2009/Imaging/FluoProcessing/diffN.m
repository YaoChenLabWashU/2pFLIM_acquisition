function out=diffN(data, n);

	len=size(data,2);
	out=data(n+1:len)-data(1:len-n);
	
	
