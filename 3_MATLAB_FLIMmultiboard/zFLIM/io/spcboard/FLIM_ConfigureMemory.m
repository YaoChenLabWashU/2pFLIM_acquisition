function FLIM_ConfigureMemory(m)
% gy multiboard modified 201202
% m is FLIM module number, from state.spc.acq.modulesInUse

global state;

data=libstruct('s_SPCMemConfig');
data.max_block_no=0;

switch state.spc.acq.SPCdata{m+1}.mode
	case 0,  
        [out1 state.spc.acq.SPCMemConfig{m+1}]=calllib('spcm32','SPC_configure_memory',m,state.spc.acq.SPCdata{m+1}.adc_resolution,0,data);
	case {2,3}
       [out1 state.spc.acq.SPCMemConfig{m+1}]=calllib('spcm32','SPC_configure_memory',m,-1,0,data);
    case {5}
        return;
    otherwise
end

if out1 ~= 0
    error = FLIM_get_error_string (out1);    
    disp(['Memory config error:', error]);
end