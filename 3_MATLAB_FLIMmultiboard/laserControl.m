function varargout = laserControl(varargin)
% LASERCONTROL M-file for laserControl.fig
%      LASERCONTROL, by itself, creates a new LASERCONTROL or raises the existing
%      singleton*.
%
%      H = LASERCONTROL returns the handle to a new LASERCONTROL or the handle to
%      the existing singleton*.
%
%      LASERCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LASERCONTROL.M with the given input arguments.
%
%      LASERCONTROL('Property','Value',...) creates a new LASERCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before laserControl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to laserControl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help laserControl

% Last Modified by GUIDE v2.5 09-Dec-2010 08:23:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @laserControl_OpeningFcn, ...
                   'gui_OutputFcn',  @laserControl_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before laserControl is made visible.
function laserControl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to laserControl (see VARARGIN)

% Choose default command line output for laserControl
handles.output = hObject;
global laserCOM laserWaveln state
% Update handles structure
guidata(hObject, handles);

success=0;
if length(state) && isfield(state,'laser')
    if state.laser.laserControlOn
        port=state.laser.port;
        baud=state.laser.baud;
    else
        port='';
    end
else
    port=get(handles.figure1,'UserData');
    if length(port)<4
        port='COM3';
    end
end

try
    isvalid(laserCOM);
catch
    laserCOM=serial(port,'baud',19200,'DataBits',8,'Parity','none');
    laserCOM.Terminator='CR/LF';
    try 
        fopen(laserCOM);
        fprintf(laserCOM,'ECHO=0'); fgets(laserCOM);
        fprintf(laserCOM,'PROMPT=0'); fgets(laserCOM);
        success=1;
    catch ME
        disp(ME.message);
        set(handles.info,'String',[ME.message char(13) char(10) 'Exit & invoke: laserControl(''UserData'',''COMn'')']);
        laserCOM=[];
    end
end
% read in the list of wavelength-dependent syncThresholds, if available
global syncThresholds
try load('syncThresholds.mat','syncThresholds'); end;

if success
    % check the current wavelength
    fprintf(laserCOM,'?VW'); waveln=fgetl(laserCOM);
    laserWaveln=str2double(waveln);
    checkPower(handles);
    checkShutter(handles);
    checkModeLock(handles);
    registerWavelength(handles);
    set(handles.waveln,'String',waveln);
end

function registerWavelength(handles)
global laserWaveln state syncThresholds laserNominalRate
if length(state) && isfield(state,'laser')
    state.laser.wavelength=laserWaveln;
    state.laser.configGlobals.wavelength=2;  % mark for storage in header
    updateHeaderString('state.laser.wavelength');
    try
    if length(syncThresholds)>0 && timerGetActiveStatus('zFLIM')
        threshold=interp1(syncThresholds(:,1),syncThresholds(:,2),laserWaveln);
        % gy multiboard
        for m=state.spc.acq.modulesAvail
            state.spc.acq.SPCdata{m+1}.sync_threshold=threshold;     
            FLIM_setParameters(m);
            FLIM_getParameters(m);
        end
        appendInfo(handles,['Sync threshold changed to ' num2str(state.spc.acq.SPCdata{1}.sync_threshold)]);
        if size(syncThresholds,2)>=3  % third column has nominal sync rate in MHz
            laserNominalRate=1E6*interp1(syncThresholds(:,1),syncThresholds(:,3),laserWaveln);
        end
        FLIM_FillParameters;  % this one fails if window not open (I think - gy)
    end
    end
end

% UIWAIT makes laserControl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = laserControl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function waveln_Callback(hObject, eventdata, handles)
% hObject    handle to waveln (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of waveln as text
%        str2double(get(hObject,'String')) returns contents of waveln as a double
global laserCOM laserWaveln laserTuningTime
% laserTuningTime is the maximum time in sec to wait for the laser status to show
% tuned.  Altered 20130712 because new laser tunes ok, but status doesn't
% correct until much later.
if isempty(laserTuningTime)
    laserTuningTime=10;
end
waveln=get(hObject,'String');
% try to set the wavelength
fprintf(laserCOM,['VW=' waveln]);
tic; % start the timer for the maximum laser tuning time
msg=fgetl(laserCOM);
set(handles.info,'String',msg);
if length(msg)<1
    fprintf(laserCOM,'?TS'); %ask for tuning status
    msg=fgetl(laserCOM); 
    while toc<laserTuningTime && str2double(msg)>0 % still tuning  
        fprintf(laserCOM,'?TS'); %ask for tuning status
        msg=fgetl(laserCOM); 
    end
    if str2double(msg)==0
        set(handles.info,'String',['Tuning completed: ' waveln]);
    end 
    % check the current wavelength
    fprintf(laserCOM,'?VW'); waveln=fgetl(laserCOM); disp(waveln);
    laserWaveln=str2double(waveln);
    checkPower(handles);
    registerWavelength(handles);
    set(handles.waveln,'String',waveln);
end


% --- Executes during object creation, after setting all properties.
function waveln_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waveln (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function info_Callback(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of info as text
%        str2double(get(hObject,'String')) returns contents of info as a double


% --- Executes during object creation, after setting all properties.
function info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkVW.
function checkVW_Callback(hObject, eventdata, handles)
% hObject    handle to checkVW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global laserCOM laserWaveln
% check the current wavelength
fprintf(laserCOM,'?VW'); waveln=fgetl(laserCOM);
laserWaveln=str2double(waveln);
set(handles.waveln,'String',waveln);
set(handles.info,'String',['Wavelength confirmed at ' waveln]);
checkPower(handles);
checkShutter(handles);
checkModeLock(handles);
registerWavelength(handles);

function checkPower(handles)
global laserCOM
fprintf(laserCOM,'?UF');
power=fgetl(laserCOM);
appendInfo(handles,['Actual power = ' power ' mW']);

function checkShutter(handles)
global laserCOM
fprintf(laserCOM,'?S');
shutter=fgetl(laserCOM);
if str2double(shutter)
    shutter='open';
else
    shutter='CLOSED';
end
appendInfo(handles,['Laser shutter is ' shutter]);

function checkModeLock(handles)
global laserCOM
fprintf(laserCOM,'?MDLK');
modelk=str2double(fgetl(laserCOM));
switch modelk
    case 0
        modeLk='*** Laser in STANDBY ***';
    case 1
        modeLk='Laser is ModeLocked';
    case 2
        modeLk='*** Laser is CW - NOT ModeLocked ***';
end
appendInfo(handles,modeLk);



function appendInfo(handles,str2)
str=get(handles.info,'String');
if ~iscell(str)
    str={str};
end
str{end+1}=str2;
set(handles.info,'String',str);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global laserCOM
if length(laserCOM)
    fclose(laserCOM);
end
laserCOM=[];
delete(hObject);



function laserCommand_Callback(hObject, eventdata, handles)
% hObject    handle to laserCommand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of laserCommand as text
%        str2double(get(hObject,'String')) returns contents of laserCommand as a double
global laserCOM
cmd=get(hObject,'String');
fprintf(laserCOM,cmd);
set(hObject,'String','');
resp=fgetl(laserCOM);
set(handles.laserResponse,'String',{cmd resp});


% --- Executes during object creation, after setting all properties.
function laserCommand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laserCommand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function laserResponse_Callback(hObject, eventdata, handles)
% hObject    handle to laserResponse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of laserResponse as text
%        str2double(get(hObject,'String')) returns contents of laserResponse as a double


% --- Executes during object creation, after setting all properties.
function laserResponse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laserResponse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
