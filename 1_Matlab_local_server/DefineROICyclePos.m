function ROIPosMatrix=DefineROICyclePos(ROIPos)
% code to segregate ROIs by cycle positions
global spc gui ROIPosMatrix
nROIs=size(gui.gy.roiPositions,2);
if exist('ROIPos') %Input in the command line the number of ROIs for each cycle position. e.g. ROIPos=[2 3 5]
    if nROIs~=sum(ROIPos)
        error('ROI positions do not add up to the number of ROIs');
    end
    nPositions=size(ROIPos);
    nPositions=nPositions(2);
    ROIPosMatrix=zeros(nPositions, nROIs); % Create a matrix with the number of rows equal to the number of cycle positions, the number of columns equal to the number of ROIs.
    n=1;
    
% Now fill in the matrix based on which ROI is from which cycle position.
    for Position=1:nPositions;
        ROIPosMatrix(Position, n:n+ROIPos(Position)-1)=1;
        n=n+ROIPos(Position);
    end
else ROIPosMatrix=ones(1, nROIs);
end

end

