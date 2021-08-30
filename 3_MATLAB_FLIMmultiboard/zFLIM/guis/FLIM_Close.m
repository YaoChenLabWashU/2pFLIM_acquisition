function FLIM_Close
global spc;
global state;
global gui;
global gh;



try
	if state.spc.acq.timer.timerRatesEVER
        if isvalid(state.spc.acq.timer.timerRates)==1
            stop(state.spc.acq.timer.timerRates);
            delete(state.spc.acq.timer.timerRates);
        end
	end
    disp('Timers are disabled');
catch
end

error = 0;
try
    FLIM_getParameters;
catch
    error = 1;
end

% gy multiboard - removed this saved setting 201202
% if error == 0
% 	SPCdata = state.spc.acq.SPCdata;
% 	pathstr=state.spc.iniFileDirectory(1:end-1); % gy 201112
% 	try
% 		save([pathstr, '\spc_init.mat'], 'SPCdata');
% 	catch
% 		disp('failed to save spc_init.mat... exiting anyway');
% 	end
% end
spc_saveSPCSetting;

% try
% 	out1 = calllib('spcm32','SPC_close');
%     if (out1~=0)
%         error = FLIM_get_error_string (out1);    
%         disp(['error during closing SPC:', error]);
%     end
% catch
%     disp('Errors!! during closing SPC');
% end

try
	unloadlibrary ('spcm32');
catch
    %disp('Errors!! during unloading spcm32');
end

try
    close(gui.spc.figure.project);
    close(gui.spc.figure.lifetimeMap);
    close(gui.spc.figure.lifetime);
    close(gui.spc.spc_main);
    %close(gui.spc.lifetimerange);
end
closereq;
