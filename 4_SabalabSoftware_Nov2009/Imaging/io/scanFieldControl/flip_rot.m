function flip_rot()

    global state
    
    if(state.acq.scanRotation<0)
        state.acq.scanRotation=state.acq.scanRotation+180;
    else
        state.acq.scanRotation=state.acq.scanRotation-180;
    end
    
    updateGUIByGlobal('state.acq.scanRotation');