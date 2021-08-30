function save_autoSetting(flag);
global state;
global gh;
global spc;


autoSetting.basename = state.files.baseName;
autoSetting.savePath = state.files.savePath;
autoSetting.cycle.delay = state.cycle.delay;
autoSetting.numberOfSlices = state.acq.numberOfZSlices;
autoSetting.zStepPerSlice = state.acq.zStepSize;
autoSetting.numberOfFrames = state.acq.numberOfFrames;
autoSetting.power = state.pcell.pcellScanning1;

autoSetting.zoomFactor = state.acq.zoomFactor;
% autoSetting.zoomones = state.acq.zoomones;
% autoSetting.zoomhundreds = state.acq.zoomhundreds;
autoSetting.scanRotation = state.acq.scanRotation;
autoSetting.scanShiftX = state.acq.scanShiftX;
autoSetting.scanShiftY = state.acq.scanShiftY;

autoSetting.fileCounter = state.files.fileCounter;


% autoSetting.configName = state.standardMode.configName;
% autoSetting.configPath = state.standardMode.configPath;

% fid = fopen([state.spc.iniFileDirectory 'spcm.ini']);
% [fileName,permission, machineormat] = fopen(fid);
% [pathstr,name,ext,versn] = fileparts(fileName);
% fclose(fid);
pathstr=state.spc.iniFileDirectory(1:end-1); % gy 201112
save([pathstr filesep 'autoSetting.mat'], 'autoSetting');

spc_filename = spc.filename;
save([pathstr filesep 'spc_backup.mat'], 'spc_filename');

spc_saveSPCSetting;

if nargin
    if flag
        saveCurrentUserSettings;
        %save([pathstr filesep 'state.mat'], 'state');
    end
end