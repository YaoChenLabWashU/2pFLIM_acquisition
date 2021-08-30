function read_autoSetting;

global state;
global gh;

load('autoSetting.mat');

basename = autoSetting.basename;
pname = autoSetting.savePath;
repeatPeriod = autoSetting.repeatPeriod;
numberOfSlices = autoSetting.numberOfSlices;
zStepPerSlice = autoSetting.zStepPerSlice;
numberOfFrames = autoSetting.numberOfFrames;
power = autoSetting.power;
fileCounter = autoSetting.fileCounter;
scanRotation = autoSetting.scanRotation;


%%%%%%%Configs
state.standardMode.configName=autoSetting.configName;
state.standardMode.configPath=autoSetting.configPath;
turnOffMenus;
turnOffExecuteButtons;
loadStandardModeConfig;
turnOnMenus;
turnOnExecuteButtons;
%setStatusString(status);


state.files.savePath=pname;
set(gh.mainControls.baseName, 'String', basename);
genericCallback(gh.mainControls.baseName);
set(gh.mainControls.fileCounter, 'String', num2str(fileCounter));
genericCallback(gh.mainControls.fileCounter);

set(gh.standardModeGUI.repeatPeriod, 'String', num2str(repeatPeriod));
genericCallback(gh.standardModeGUI.repeatPeriod);

set(gh.standardModeGUI.numberOfSlices, 'String', num2str(numberOfSlices));
genericCallback(gh.standardModeGUI.numberOfSlices);
state.acq.numberOfZSlices=state.standardMode.numberOfZSlices;
updateGUIByGlobal('state.acq.numberOfZSlices');
preallocateMemory;

set(gh.standardModeGUI.zStepPerSlice, 'String', num2str(zStepPerSlice));
genericCallback(gh.standardModeGUI.zStepPerSlice);
state.acq.zStepSize=state.standardMode.zStepPerSlice;
updateHeaderString('state.acq.zStepSize');
    
set(gh.standardModeGUI.numberOfFrames, 'String', num2str(numberOfFrames));
genericCallback(gh.standardModeGUI.numberOfFrames);
state.acq.numberOfFrames=state.standardMode.numberOfFrames;
updateGUIByGlobal('state.acq.numberOfFrames');
preallocateMemory;
alterDAQ_NewNumberOfFrames;

set(gh.powerControl.maxPower_Slider, 'value', power);
genericCallback(gh.powerControl.maxPower_Slider);
state.init.eom.maxPower(state.init.eom.beamMenu) = round(state.init.eom.maxPowerDisplaySlider);
state.init.eom.changed(state.init.eom.beamMenu)=1;
ensureEomGuiStates;

state.acq.zoomtens=autoSetting.zoomtens;
state.acq.zoomones=autoSetting.zoomones;
state.acq.zoomhundreds = autoSetting.zoomhundreds;
state.acq.scaleXShift = autoSetting.scaleXShift;
state.acq.ScaleYShift = autoSetting.scaleYShift;

updateGUIByGlobal('state.acq.zoomones');
updateGUIByGlobal('state.acq.zoomtens');
updateGUIByGlobal('state.acq.zoomhundreds');
updateGUIByGlobal('state.acq.scaleXShift');
updateGUIByGlobal('state.acq.scaleYShift');

state.acq.zoomFactor=str2num([num2str(round(state.acq.zoomhundreds))...
        num2str(round(state.acq.zoomtens)) num2str(round(state.acq.zoomones))]);
if state.acq.zoomFactor < 1
    state.acq.zoomFactor=1;
    state.acq.zoomones=1;
    updateGUIByGlobal('state.acq.zoomones');
end
setScanProps(gh.mainControls.zoomonesslider);

h = gh.mainControls.scanRotation;
set(h, 'String', num2str(scanRotation));
genericCallback(h);
setScanProps(h);


cd(pname);