function timerSetup_zFLIM
% GY
% from FLIM_setupScanning (focus) -- only does grab mode

global state RFswitchOutput

if ~isempty(RFswitchOutput)
    % enable the RF switches for those channels used for FLIM
    chansEnable=bitget(state.spc.FLIMchoices,2);
    % this sets the active channels to the opposite of the offState
    putvalue(RFswitchOutput, xor(state.spc.init.RFswitchesOffState,chansEnable(1:4)));
end
    

for m=state.spc.acq.modulesInUse  % gy multiboard 201202
    
    % GY: trigger 1 is active low, trigger 2 is active hi
    % state.spc.acq.SPCdata{m+1}.trigger = 1;  % GY: this WAS in Grab button code before this code; not sure of correct setting...
    state.spc.acq.SPCdata{m+1}.trigger = 0;  % GY: this WAS 2.  Changed to 0 for no external trigger (is default 1st FRAME clk)?
    
    error = 0;
    
    state.spc.acq.SPCdata{m+1}.scan_borders = 0;
    state.spc.acq.SPCdata{m+1}.scan_polarity = 0;
    state.spc.acq.SPCdata{m+1}.pixel_clock = 0;  % GY:  internally generated pixel clock
    
    state.spc.acq.SPCdata{m+1}.stop_on_time = 0;
    
    state.spc.acq.SPCdata{m+1}.mode = 2;
    state.spc.acq.SPCdata{m+1}.collect_time = state.acq.numberOfFrames*state.acq.linesPerFrame*state.acq.msPerLine*2;
    
    if state.acq.pixelsPerLine*state.acq.linesPerFrame <= 256*256 % this limit should be set more correctly (GY)
        state.spc.acq.SPCdata{m+1}.scan_size_x = state.acq.pixelsPerLine;
        % gy modified for dualLaserMode 201204
        if state.acq.dualLaserMode==1
            state.spc.acq.SPCdata{m+1}.scan_size_y = state.acq.linesPerFrame;
        elseif state.acq.dualLaserMode==2
            state.spc.acq.SPCdata{m+1}.scan_size_y = 2*state.acq.linesPerFrame;
        end
        if state.spc.acq.SPCdata{m+1}.mode == 2
            state.spc.acq.SPCdata{m+1}.img_size_x = 1;
            state.spc.acq.SPCdata{m+1}.img_size_y = 1;
        elseif state.spc.acq.SPCdata{m+1}.mode == 5  % gy note that dualLaserMode NOT ok for this mode
            state.spc.acq.SPCdata{m+1}.img_size_x = state.acq.pixelsPerLine;
            state.spc.acq.SPCdata{m+1}.img_size_y = state.acq.linesPerFrame;
        end
    else
        beep;
        disp('SPC/FLIM Error: change pixelsPerLine and state.acq.linesPerFrame to < 256 * 256');
        error = 1;
        return;
    end
    
    state.spc.acq.SPCdata{m+1}.pixel_time = 1/(state.acq.inputRate/state.acq.binFactor);
    state.spc.acq.SPCdata{m+1}.line_compression = 1;
    
    if state.spc.acq.spc_binning == 1
        binfactor = state.spc.acq.binFactor;
        state.spc.acq.SPCdata{m+1}.scan_size_x  =  floor(state.spc.acq.SPCdata{m+1}.scan_size_x / binfactor) ;
        state.spc.acq.SPCdata{m+1}.scan_size_y  =  floor(state.spc.acq.SPCdata{m+1}.scan_size_y / binfactor) ;
        state.spc.acq.SPCdata{m+1}.pixel_time = state.spc.acq.SPCdata{m+1}.pixel_time * binfactor;
        state.spc.acq.SPCdata{m+1}.line_compression = binfactor;
        state.spc.acq.SPCdata{m+1}.scan_borders = state.spc.acq.SPCdata{m+1}.scan_borders/binfactor;
    end
    if state.spc.acq.spc_average == 0
        state.spc.acq.SPCdata{m+1}.scan_size_y = state.spc.acq.SPCdata{m+1}.scan_size_y*state.acq.numberOfFrames;
    end
    
    %state.spc.acq.SPCdata{m+1}.adc_resolution = state.spc.acq.resolution;
    
    FLIM_setParameters(m);
    FLIM_getParameters(m);
    
end

% GY 2010/08: if we stop at this point and leave the rest (resetting, etc) for the
% timerStart_zFLIM function, then it should work better if and when we
% change the code to be compatible with doing a z-stack (right now, we would 
% need to hook into the Imaging function endAcquisition in order to do this
% correctly. 
    

