function updateNavigator
    global state
    
    try
        if(state.navigator.usingNav<0.5)
            return
        end
    catch
        return
    end
    
    sX=size(state.navigator.storedMaxImage, 1);
    sY=size(state.navigator.storedMaxImage, 2);
    
    spotY=sX/2+(sX/2)*state.acq.postRotOffsetX/(state.acq.scanAmplitudeX/state.navigator.navZoom);
    spotX=sY/2+(sY/2)*state.acq.postRotOffsetY/(state.acq.scanAmplitudeY/state.navigator.navZoom);
    %spotY=sX/2%+sX*state.acq.postRotOffsetX*(state.acq.scanAmplitudeX);
    %spotX=sY/2%+sY*state.acq.postRotOffsetY*(state.acq.scanAmplitudeY);
    
    spotX=round(spotX);
    spotY=round(spotY);  
 
    if(spotX<2)
        spotX=2;
    end

    if(spotX>sX-1)
        spotX=sX-1;
    end

    if(spotY<2)
        spotY=2;
    end

    if(spotY>sY-1)
        spotY=sY-1;
    end
    
    figure(state.navigator.navFigure)
    if(~isfield(state.navigator,'spot'))
        hold on
        state.navigator.spot = plot(spotX,spotY,'r+');
    else
        set(state.navigator.spot,'XData',spotX,'YData',spotY);
    end
    %to delete spot, delete(s.n.spot) then rmfield(state.navigator,'spot')
   %     plot(spotX,spotY,'r+')
 
    
