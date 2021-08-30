function out=mode(data)
	data=reshape(round(data), 1, prod(size(data)));
	low=min(data);
	high=max(data);
	[n, x]=hist(data, low:high);
	[val, pos]=max(n);
	out=x(pos);