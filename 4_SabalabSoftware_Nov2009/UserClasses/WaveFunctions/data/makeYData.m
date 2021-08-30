function YData = makeYData(wv)
% takes a wave as an inpout now...
% makes the XData and YData  for plotting of a wave input
% Formats any plot with thsi data
% For 2D waves, the outpu tis a 2 rowed by 2 col 
% with teh start adn stop pixel located.
    YData=[];
    if iswave(wv)
        if ischar(wv)
            wv=get(wv);
        end
    elseif ~isstruct(wv) | (~isfield(wv,'data') & ~isfield(wv,'yscale'))
        error('makeYData: input must be a wave');
    end
   
    scale=wv.yscale;
    sz=waveSize(wv);
    
    if ~isempty(wv.data)
        YData = scale(1) : scale(2) : scale(1)+scale(2)*(sz(1)-1);
    else
        YData=NaN;
    end