function out=smooth(in, n)
	if nargin<2
		n=3;
	end
	
	out=filter(repmat(1/n, 1, n), 1, in);
	out(1:n)=mean(in(1:n));
	
    