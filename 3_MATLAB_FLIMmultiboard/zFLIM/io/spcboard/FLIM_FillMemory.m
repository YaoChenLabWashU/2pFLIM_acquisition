function FLIM_FillMemory (m,page)
% gy multiboard modified 201202
% m is FLIM module number, from state.spc.acq.modulesInUse
global state;

%block = state.spc.acq.SPCMemConfig.blocks_per_frame*state.spc.acq.SPCMemConfig.frames_per_page;
if nargin<2
    page = -1;
end
switch state.spc.acq.SPCdata{m+1}.mode
	case {0,1}
		for i=0:state.spc.acq.SPCMemConfig{m+1}.blocks_per_frame-1
            out1=calllib('spcm32','SPC_fill_memory',m,i,0,0);
			if out1 ~= 0
                error = FLIM_get_error_string (out1);    
                disp(['Memory filling error:', error]);
                return;
			end
		end
    case {2,3,5}   
        block = -1;
        out1=calllib('spcm32','SPC_fill_memory',m,block,page,0);
        pause(0.1);
        filled = FLIM_ifmemoryfilled(m);
    	if ~filled
            for i=1:1000
                pause(0.05);
                filled = FLIM_ifmemoryfilled(m);
                if filled
                    break
                end
            end
		end
        if ~filled
            disp('Memory was not filled !!!');
        else
           % disp('Memory was successfully filled');
        end
    otherwise
end

