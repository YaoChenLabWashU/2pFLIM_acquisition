function FLIM_TimerFunctionRates
% updates the display of SYNC/CFD/TAC/ADC counts from SPC board
global state;
global gh;
global laserNominalRate

if ~state.spc.internal.ifstart
    for m=state.spc.acq.modulesAvail  % gy multiboard 201202
        if m==0
            sync='edit2'; cfd='edit3'; tac='edit4'; adc='edit5';
        else
            sync='edit2b'; cfd='edit3b'; tac='edit4b'; adc='edit5b';
        end
        data=libstruct('s_rate_values');
        data.sync_rate=0;
        [out1 data]=calllib('spcm32','SPC_read_rates',m,data);
        if out1
            % disp(['rate error on module ' num2str(m)]);
            return
        end
        if length(laserNominalRate)==1 && data.sync_rate/laserNominalRate<0.98
            set(gh.spc.FLIMgui.(sync),'BackgroundColor','red');
        else
            set(gh.spc.FLIMgui.(sync),'BackgroundColor',[.941 .941 .941]);
        end
        
        
        % added GY 201101
        state.spc.internal.syncRate = data.sync_rate;
        
        data.sync_rate=strrep(sprintf('%.3e',data.sync_rate),'e+00',' e+');
        set(gh.spc.FLIMgui.(sync),'String',data.sync_rate);
        
        if data.cfd_rate>0
            data.cfd_rate=strrep(sprintf('%.3e',data.cfd_rate),'e+00',' e+');
            data.tac_rate=strrep(sprintf('%.3e',data.tac_rate),'e+00',' e+');
            data.adc_rate=strrep(sprintf('%.3e',data.adc_rate),'e+00',' e+');
            
            set(gh.spc.FLIMgui.(cfd),'String',data.cfd_rate);
            set(gh.spc.FLIMgui.(tac),'String',data.tac_rate);
            set(gh.spc.FLIMgui.(adc),'String',data.adc_rate);
        end
    end
end

