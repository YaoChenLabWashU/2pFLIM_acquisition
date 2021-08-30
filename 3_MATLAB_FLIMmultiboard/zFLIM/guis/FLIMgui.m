% #########################################################################
% FLIMgui v1.0r100 --- Modified Gary Yellen (GY) Harvard Medical School 8/2010
% Ryohei Yasuda, Aleksander Sobczyk
% Cold Spring Harbor Labs
% #########################################################################

function varargout = FLIMgui(varargin)
% FLIMGUI M-file for FLIMgui.fig
%      FLIMGUI, by itself, creates a new FLIMGUI or raises the existing
%      singleton*.
%
%      H = FLIMGUI returns the handle to a new FLIMGUI or the handle to
%      the existing singleton*.
%
%      FLIMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLIMGUI.M with the given input arguments.
%
%      FLIMGUI('Property','Value',...) creates a new FLIMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FLIMgui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FLIMgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FLIMgui

% Last Modified by GUIDE v2.5 19-Apr-2012 11:41:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FLIMgui_OpeningFcn, ...
                   'gui_OutputFcn',  @FLIMgui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% #########################################################################
% --- Executes just before FLIMgui is made visible.
function FLIMgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FLIMgui (see VARARGIN)

% Choose default command line output for FLIMgui
global gh;
global state;
global gui;
global spc
gh.spc.FLIMgui = handles;
handles.output = hObject;
gh.spc.FLIMgui.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FLIMgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% openini('flim.ini');
% try
%     stopGrab;
%     spc_setupPixelClockDAQ_Common;
%     spc_stopGrab;
% catch
% end
% 
% handles=FLIM_Init(hObject,handles);
% guidata(hObject,handles);
% 
if ~isfield(state,'spc') || ~isfield(state.spc,'FLIMchoices')
    state.spc.FLIMchoices=zeros(1,6);
else
    setupFLIMchoices(handles);
end

% gy 201112
% enable buttongroups and set defaults
initializeImageSelectors(handles);
set(handles.img1sel,'SelectionChangeFcn',@img1sel_Callback);
set(handles.img4sel,'SelectionChangeFcn',@img4sel_Callback);

% 
% pause(0.1)

%%%%Set Initial values%%%%%%%%%%%%%%%%%%
% set(handles.image, 'Value', state.spc.acq.spc_image);
set(handles.flimcheck, 'Value', 1); 
set(handles.flimcheck, 'Enable', 'inactive');
%set(handles.checkbox3, 'Value', state.spc.acq.spc_binning);
set(handles.checkbox1,'Value', 1);
%set(handles.checkbox3,'Value', 0); %Binning
% set(handles.Uncage, 'Value', 0);
set(handles.BinFPop, 'Value', 1);
% set(handles.uncageEveryFrame, 'Value', state.spc.acq.uncageEveryXFrame);


state.spc.acq.spc_binning = 0;
%GY (temporary??) out1=calllib('spcm32','SPC_clear_rates',state.spc.acq.module);
state.spc.acq.timer.timerRatesEVER=true;
state.spc.acq.timer.timerRates=timer('TimerFcn','FLIM_TimerFunctionRates','ExecutionMode','fixedSpacing','Period',2.0);
start(state.spc.acq.timer.timerRates);

% no longer launch the spc_main (spc_drawInit) GUI immediately
FLIMstartupPrompt;

% #########################################################################
% --- Outputs from this function are returned to the command line.
function varargout = FLIMgui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% #########################################################################
function FLIM_MenuFile_Callback(hObject, eventdata, handles)

% #########################################################################
function FLIM_MenuFileExit_Callback(hObject, eventdata, handles)
FLIM_Close;

% #########################################################################
function FLIM_MenuParameters_Callback(hObject, eventdata, handles)
FLIM_Parameters;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc
%    set(hObject,'BackgroundColor','white');
%else
%    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
%end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

global state;


if(isvalid(state.spc.acq.timer.timerRates)==1) && (get(hObject,'Value')==1)
    % gy multiboard 201202
    for m=state.spc.acq.modulesAvail
        out1=calllib('spcm32','SPC_clear_rates',m);
    end
    state.spc.acq.timer.timerRatesEVER=true;
    state.spc.acq.timer.timerRates=timer('TimerFcn','FLIM_TimerFunctionRates','ExecutionMode','fixedSpacing','Period',2.0);
    start(state.spc.acq.timer.timerRates);
end

if (isvalid(state.spc.acq.timer.timerRates)==1)&(get(hObject,'Value')==0)
    set(handles.edit2,'String','');
    set(handles.edit3,'String','');
    set(handles.edit4,'String','');
    set(handles.edit5,'String','');
    set(handles.edit2b,'String','');
    set(handles.edit3b,'String','');
    set(handles.edit4b,'String','');
    set(handles.edit5b,'String','');
    stop(state.spc.acq.timer.timerRates);
    %delete(state.spc.acq.timer.timerRates);
end

% --- Executes on button press in image.
function image_Callback(hObject, eventdata, handles)
% hObject    handle to image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of image


global state;

value = get(hObject, 'Value');
state.spc.acq.spc_image = value;


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
global state;
value=get(hObject, 'Value');
state.spc.acq.spc_binning = value;
%GY    if FLIM_setupScanning(0)
%         return;
%     end    

% --- Executes during object creation, after setting all properties.
function BinFPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BinFPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in BinFPop.
function BinFPop_Callback(hObject, eventdata, handles)
% hObject    handle to BinFPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns BinFPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BinFPop

global state;
value=get(hObject, 'Value');
state.spc.acq.binFactor= 2^(value-1);
state.spc.acq.spc_binning = 1;
set(handles.checkbox3, 'Value', 1);
%GY:    if FLIM_setupScanning(0)
%         return;
%     end   



% --- Executes on button press in flimcheck.
function flimcheck_Callback(hObject, eventdata, handles)
% hObject    handle to flimcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flimcheck

global state;

value = get(hObject, 'Value');
state.spc.acq.spc_takeFLIM = value;


% --- Executes on button press in AveFrame.
function AveFrame_Callback(hObject, eventdata, handles)
% hObject    handle to AveFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AveFrame

global state;
value = get(hObject, 'Value');
state.spc.acq.spc_average = value;


% --- Executes on button press in Acq/Calc checkboxes.
function leftCB_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of acq2
val=get(hObject,'Value');
% always make the corresponding show checkbox to the same val
% as a starting default
tag=get(hObject,'Tag');
num=tag(end);
set(handles.(['show' num]),'Value',val);
readChannelChoices(handles);



% --- Executes on button press in Show checkboxes.
function rightCB_Callback(hObject, eventdata, handles)
% hObject    handle to acq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of acq2
readChannelChoices(handles);

function readChannelChoices(handles)
global state
% chansToDisplay=find(bitget(state.spc.FLIMchoices,1));
% chansToAcquire=find(bitget(state.spc.FLIMchoices,2));
% chansToCalculate=find(bitget(state.spc.FLIMchoices,3));
tags={'acq' 'acq' 'acq' 'acq' 'calc' 'calc'};
for k=1:6
    cbLeft=handles.([tags{k} num2str(k)]);
    cbRight=handles.(['show' num2str(k)]);
    if (k<=4)
        state.spc.FLIMchoices(k)=2*get(cbLeft,'Value')+get(cbRight,'Value');
    else
        state.spc.FLIMchoices(k)=4*get(cbLeft,'Value')+get(cbRight,'Value');
    end
end

function setupFLIMchoices(handles)
global state
tags={'acq' 'acq' 'acq' 'acq' 'calc' 'calc'};
for k=1:6
    cbLeft=handles.([tags{k} num2str(k)]);
    cbRight=handles.(['show' num2str(k)]);
    if (k<=4)
        set(cbLeft,'Value',bitget(state.spc.FLIMchoices(k),2));
        if state.spc.acq.channelDefs(k,1)>0
            set(handles.(['def' num2str(k)]),'String',...
                ['m' num2str(state.spc.acq.channelDefs(k,1)) ' : c' ...
                num2str(state.spc.acq.channelDefs(k,2))]);
        else
            set(handles.(['def' num2str(k)]),'String','undefined');
        end
    else
        set(cbLeft,'Value',bitget(state.spc.FLIMchoices(k),3));
    end
    set(cbRight,'Value',bitget(state.spc.FLIMchoices(k),1));
end


% --- Executes on button press in relaunch.
function relaunch_Callback(hObject, eventdata, handles)
% hObject    handle to relaunch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gui state
if isfield(gui,'spc') && isfield(gui.spc,'spc_main')
    try close(gui.spc.spc_main.spc_main); end
else
    set(hObject,'String','Restart GUI');
end

% gy multiboard 201202
% combine information on FLIMchoices, channelDefs
chansToAcquire=find(bitget(state.spc.FLIMchoices,2));
state.spc.acq.modulesInUse=[]; modInUse=[];
state.spc.acq.modChans={}; modChans={};
for ch=chansToAcquire
    % channelDefs row has board, frame
    board=state.spc.acq.channelDefs(ch,1);
    frame=state.spc.acq.channelDefs(ch,2);
    if board==0
        disp(['timerInit_zFLIM ERROR: channel ' num2str(ch) ' requested but not defined']);
    else
        m=board-1; % numbering is different
        if isempty(find(modInUse==m, 1))
            modInUse(end+1)=m; % add to list
            modChans{m+1}=[];
        end
        modChans{m+1}(end+1,1)=frame;
        modChans{m+1}(end,2)=ch; 
        if frame>state.spc.acq.SPCdata{m+1}.scan_rout_x
            wrn=['SPC Board ' num2str(board) 'NEEDS TO ACQUIRE MORE CHANNELS:  set Scan_Rout_X in PARAMETERS'];
            warndlg(wrn,'FLIM acquisition mismatch (timerInit_zFLIM)');
        end
    end
end
state.spc.acq.modulesInUse=modInUse;
state.spc.acq.modChans=modChans;

spc_drawInit;


% --- Executes on button press in img4divN.
function img4divN_Callback(hObject, eventdata, handles)
global state
state.spc.acq.imageChannel4divN=get(hObject,'Value');

% --- Executes on button press in img1divN.
function img1divN_Callback(hObject, eventdata, handles)
global state
state.spc.acq.imageChannel1divN=get(hObject,'Value');

function img2divN_Callback(hObject, eventdata, handles)
global state
state.spc.acq.imageChannel2divN=get(hObject,'Value');


function img1sel_Callback(hObject, eventdata, handles);
global state
tagSel=get(get(hObject,'SelectedObject'),'Tag'); % tag of selection
state.spc.acq.imageChannel1content=str2double(tagSel(end));

function img2sel_Callback(hObject, eventdata, handles);
global state
tagSel=get(get(hObject,'SelectedObject'),'Tag'); % tag of selection
state.spc.acq.imageChannel2content=str2double(tagSel(end));


function img4sel_Callback(hObject, eventdata, handles);
global state
tagSel=get(get(hObject,'SelectedObject'),'Tag'); % tag of selection
state.spc.acq.imageChannel4content=str2double(tagSel(end));

function initializeImageSelectors(handles)
global state
set(handles.img1divN,'Value',state.spc.acq.imageChannel1divN);
set(handles.img2divN,'Value',state.spc.acq.imageChannel2divN);
set(handles.img4divN,'Value',state.spc.acq.imageChannel4divN);
tagOn=['rbA' num2str(state.spc.acq.imageChannel1content)];
set(handles.(tagOn),'Value',1);
tagOn=['rbB' num2str(state.spc.acq.imageChannel2content)];
set(handles.(tagOn),'Value',1);
tagOn=['rbC' num2str(state.spc.acq.imageChannel4content)];
set(handles.(tagOn),'Value',1);



function edit2b_Callback(hObject, eventdata, handles)
% hObject    handle to edit2b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2b as text
%        str2double(get(hObject,'String')) returns contents of edit2b as a double


% --- Executes during object creation, after setting all properties.
function edit2b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3b_Callback(hObject, eventdata, handles)
% hObject    handle to edit3b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3b as text
%        str2double(get(hObject,'String')) returns contents of edit3b as a double


% --- Executes during object creation, after setting all properties.
function edit3b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4b_Callback(hObject, eventdata, handles)
% hObject    handle to edit4b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4b as text
%        str2double(get(hObject,'String')) returns contents of edit4b as a double


% --- Executes during object creation, after setting all properties.
function edit4b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5b_Callback(hObject, eventdata, handles)
% hObject    handle to edit5b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5b as text
%        str2double(get(hObject,'String')) returns contents of edit5b as a double


% --- Executes during object creation, after setting all properties.
function edit5b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


