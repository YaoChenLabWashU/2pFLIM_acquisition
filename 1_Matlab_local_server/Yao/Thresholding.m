function Thresholding = Thresholding(threshold);
%The function thresholds a distribution of prf, and then normalizes the sum to 1.  The input argument specifies the
%threshold.
load('prfsim.mat');
for i=1:length(prfsim)
    if prfsim(i)>threshold, prfsim(i)=prfsim(i)-threshold;
    else prfsim(i)=0;
    end
end
prfsim=prfsim/sum(prfsim);
save('prfsim.mat', 'prfsim')
end

