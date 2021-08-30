function [leftEdge, rightEdge]=contiguousRange(start, vector)
	
	if start>1
		leftEdge=max(find(vector(2:start).*(1-vector(1:start-1))));
		if isempty(leftEdge)
			leftEdge=1;
		else
			leftEdge=leftEdge+1;
		end
	else
		leftEdge=1;
	end

	if start<length(vector)
		rightEdge=min(find(vector(start:end-1).*(1-vector(start+1:end))));
		if isempty(rightEdge)
			rightEdge=length(vector);
		else
			rightEdge=start-1+rightEdge;
		end
	else
		rightEdge=length(vector);
	end
	
