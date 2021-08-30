function out=displaySetValue(in)
%Outputs what we can set the values in the wave fields to.

if strcmp(in,'data')
    out=[in ': array (0 to 2D)'];
elseif strcmp(in,'xscale') | strcmp(in,'yscale') | strcmp(in,'zscale') 
    out=[in ': 2 element array'];
elseif strcmp(in,'note') 
    out=[in ': char'];
elseif strcmp(in,'UserData') 
    out=[in ': struct '];
elseif strcmp(in,'plot')
    out=[in ': handle to graphic object of type line (1D) or image (2D)'];
elseif strcmp(in,'holdUpdates')
    out=[in ': 1 or 0 '];
elseif strcmp(in,'needsReplot')
    out=[in ': 1 or 0'];
else
    out='';
end