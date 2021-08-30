function timerInit_zFLIM
% open up FLIM configuration windows
%   photon count monitor window
% open up FLIM fitting windows
% gy multiboard 201202
global gui state
evalin('base','global spc');
openini('zFLIM.ini');

% loads library and initializes SPC module parameters
FLIM_Init; 

% launch laserControl
gui.spc.figure.laser=laserControl;

% open FLIM channel choice / photon count monitor window and FLIM-specific windows 
FLIMgui;  

% Setup RF switches if needed
initializeRFswitches;




    

