function XData = makeXData(wv)
% takes a wave as an inpout now...
% makes the XData and YData  for plotting of a wave input
% Formats any plot with thsi data
% For 2D waves, the outpu tis a 2 rowed by 2 col 
% with teh start adn stop pixel located.

	XData=[];
    if iswave(wv)
        if ischar(wv)
            wv=getWave(wv);
        end
    elseif ~isstruct(wv) | (~isfield(wv,'data') & ~isfield(wv,'xscale'))
        error('makeXData: input must be a wave');
    end
   
    scale=wv.xscale;
    sz=waveSize(wv);
    
    if ~isempty(wv.data)
        XData = scale(1) : scale(2) : scale(1)+scale(2)*(sz(2)-1);
    else
        XData=NaN;
    end
