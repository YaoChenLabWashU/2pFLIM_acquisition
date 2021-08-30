function FLIM_Init()
% modified gy multiboard/multichannel 201202
% from RY 201008 FLIM_Init modified gy 20100817
%   no longer uses storage in handles
%
%  Loads SPCM library and initializes it
%  Uses 'spcm.ini' to initialize the SPC library/module
%    >>> but then asks user for a .ini file (MAT file) to 
%        initialize the actual multiple module parameters!
%  gets parameters back from board and saves in state.spc.acq.SPCdata
%      (using call to FLIM_getParameters)
%  initializes two Timers (state.spc.acq.mt, state.spc.acq.mtSingle)
%      (both at 1 sec intervals)
%      FLIM_image_timer and FLIM_TimerFunction

global state;

% GY     clc;

state.spc.acq.ifStart = false;
state.spc.acq.ifInactive = true;

try upath=userpath; cd('c:\'); end  % get us out of any Current Folder choice gy 201204
state.spc.iniFileDirectory = [fileparts(which('machineSpecific.ini')) filesep];
try (cd(state.spc.iniFileDirectory)); end

%state.spc.FLIMchoices=[3 3 0 0 0 0];
disp('FLIMimage v2.0 - gy multiboard 2012');
disp('---------------');

if libisloaded('spcm32')
    unloadlibrary('spcm32');
end
FLIM_LoadLibrary('spcm32','spcm_def.h');

error_code=calllib('spcm32','SPC_init',[state.spc.iniFileDirectory 'spcm.ini']);
error_string = FLIM_get_error_string(error_code);
disp(sprintf('Initialization: %s',error_string));

if error_code < 0
    module_type = 150;
    disp('Failed to initialize SPC');
    % gy multiboard 201202 simulate two modules
    [result, inuse] = calllib('spcm32','SPC_set_mode',module_type,1,[1 1 0 0 0 0 0 0]);
    if any(result>=0) || inuse ~= 1
        disp(sprintf('Entering simulation mode: %i',result));
    end
end

state.spc.acq.modulesAvail=[];
state.spc.acq.SPCModInfo={};
state.spc.acq.SPCdata={};
j=0;
    
for i=0:1  % gy multiboard 201202 check for 1-2 modules
    disp(['Testing modules: ' num2str(i)]);
    ModInfo=libstruct('s_SPCModInfo');
    ModInfo.module_type=0;
    [out1 SPCModInfo]=calllib('spcm32','SPC_get_module_info',i,ModInfo);
    if SPCModInfo.in_use==1
        state.spc.acq.modulesAvail(end+1)=i;
    elseif 0 % gy multiboard 201202 old condition: SPCModInfo.in_use == -1
        disp('Failed to initialize SPC. Forcing to use the hardware...');
        state.spc.acq.module = i;
        result = calllib('spcm32','SPC_set_mode',SPCModInfo.module_type,1,[1 0 0 0 0 0 0 0]);
        [out1 SPCModInfo]=calllib('spcm32','SPC_get_module_info',i,ModInfo);
        if SPCModInfo.in_use == 1
            disp('Done');
            if result>=0
                disp(sprintf('Entering simulation mode: %i',result));
            end
        elseif SPCModInfo.in_use == -1
            disp('Module is in use. SPC module is forced to turn on -- 2nd trial!');
            result = calllib('spcm32','SPC_set_mode',SPCModInfo.module_type,1,[1 0 0 0 0 0 0 0]);
            [out1 SPCModInfo]=calllib('spcm32','SPC_get_module_info',i,ModInfo);
            pause(0.1);
            if SPCModInfo.in_use == 1
                disp('Done');
                if result>=0
                    disp(sprintf('Entering simulation mode: %i',result));
                end;
            elseif SPCModInfo.in_use == -1
                disp('Module is in use. SPC module is not installed');
                return;
            end
        end
    end
    
    
    error_code_1=calllib('spcm32','SPC_test_id',i);
    error_code_2=calllib('spcm32','SPC_get_init_status',i);
    if (error_code_1>0)&&(error_code_2==0)
        state.spc.acq.SPCModInfo{i+1} = SPCModInfo;  % gy multiboard
        j=j+1;
        disp(sprintf('\tModule %i: %i',i,error_code_1));
        disp(sprintf('\t\tModule type:\t%i',SPCModInfo.module_type));
        disp(sprintf('\t\tBus number:\t\t%i',SPCModInfo.bus_number));
        disp(sprintf('\t\tSlot number:\t%i',SPCModInfo.slot_number));
        disp(sprintf('\t\tIn use:\t\t\t%i',SPCModInfo.in_use));
        disp(sprintf('\t\tInit:\t\t\t%i',SPCModInfo.init));
        disp(sprintf('\t\tBase address:\t%i',SPCModInfo.base_adr));
        FLIM_getParameters(i); % GY:  stores in state.spc.acq.SPCdata{:}
    end
end % for multiple modules
    
if (j==0)
    disp('  No modules found');
    return;
else
    disp(['Active module(s): ',num2str(state.spc.acq.modulesAvail)]);
end

% gy multiboard 2012
% now load the ACTUAL initial SPC module parameters from an .ini file
% saved by us (internally a .mat file, potentially with multiple module
% settings)
fileName=state.spc.acq.spcmIniFile;
[fileName,pathName]=uigetfile('spc*.ini','Select SPC board parameter file',[state.spc.iniFileDirectory fileName]);
[fid, message]=fopen([pathName fileName]);
if fid<0
    disp(['Error opening ' fileName ': ' message]);
    return
end

[fileName,~, ~] = fopen(fid);
fclose(fid);
disp(['*** CURRENT INI FILE = ' fileName ' ***']);
FLIM_LoadIniFile(fileName);




%state.spc.acq.module = 0;

% guidata(hObject,handles);
% 


% set(handles.edit1, 'String', '00:00');
% gy multiboard 2012: not sure this stuff is meaningful now
% if (exist([state.spc.iniFileDirectory 'spc_init.mat']) == 2)
%     fid = fopen([state.spc.iniFileDirectory 'spc_init.mat']);
%     [fileName,~,~] = fopen(fid);
%     fclose(fid);
%     state.spc.files.iniFile = fileName;
%     load (fileName);
%     state.spc.acq.SPCdata = SPCdata;
%     FLIM_setParameters;
%     FLIM_getParameters;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Timer setting

% state.spc.acq.mt=timer('TimerFcn','FLIM_image_timer','ExecutionMode','fixedSpacing','Period',1.0);
% state.spc.acq.mtSingle=timer('TimerFcn','FLIM_TimerFunction','ExecutionMode','fixedSpacing','Period',1.0);
% result=handles;
