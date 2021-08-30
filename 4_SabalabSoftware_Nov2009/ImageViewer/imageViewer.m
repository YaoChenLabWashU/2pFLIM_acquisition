function varargout = imageViewer(varargin)
% IMAGEVIEWER M-file for imageViewer.fig
%      IMAGEVIEWER, by itself, creates a new IMAGEVIEWER or raises the existing
%      singleton*.
%
%      H = IMAGEVIEWER returns the handle to a new IMAGEVIEWER or the handle to
%      the existing singleton*.
%
%      IMAGEVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEVIEWER.M with the given input arguments.
%
%      IMAGEVIEWER('Property','Value',...) creates a new IMAGEVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageViewer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageViewer

% Last Modified by GUIDE v2.5 09-Oct-2006 17:13:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @imageViewer_OutputFcn, ...
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


% --- Executes just before imageViewer is made visible.
function imageViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageViewer (see VARARGIN)

% Choose default command line output for imageViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imageViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imageViewer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function fileName_Callback(hObject, eventdata, handles)
function fileBaseName_Callback(hObject, eventdata, handles)
	genericCallback(hObject);

function acqCounter_Callback(hObject, eventdata, handles)

function generic_Callback(hObject, eventdata, handles)
	genericCallback(hObject)

function shiftChange_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	ivApplyShiftToLines;
	ivUpdateReferenceImage;

function toggleWindow_Callback(hObject, eventdata, handles)
	global state
	tag=get(hObject, 'Tag');
	f=strfind(tag, 'ow');
	channel=str2num(tag(f+2:f+3));
	if isempty(channel)
		channel=str2num(tag(f+2));
	end
	switch get(state.imageViewer.figure(channel), 'visible')
		case 'on'
			set(state.imageViewer.figure(channel), 'visible', 'off');
		case 'off'
			set(state.imageViewer.figure(channel), 'visible', 'on');
	end

function nSlices_Callback(hObject, eventdata, handles)
function nPixelsX_Callback(hObject, eventdata, handles)
function nPixelsY_Callback(hObject, eventdata, handles)
function zoom_CreateFcn(hObject, eventdata, handles)
function dualScanMode_Callback(hObject, eventdata, handles)

function updateFigures_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	ivUpdateFigures;

function updateLUT_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	tag=get(hObject, 'Tag');
	f=strfind(tag, 'LUT');
	if length(tag)>=f+4
		channel=str2num(tag(f+3:f+4));
	else
		channel=[];
	end
	if isempty(channel)
		channel=str2num(tag(f+3));
	end
	ivUpdateLUT(channel);

function zoom_Callback(hObject, eventdata, handles)

function medianFilterButton_Callback(hObject, eventdata, handles)
	ivMedianFilter;

function projectButton_Callback(hObject, eventdata, handles)
	ivMaxProjectZ;

function currentSelection_Callback(hObject, eventdata, handles)
	genericCallback(hObject);


function setReference_Callback(hObject, eventdata, handles)
	ivSetTrackerReference;

function trackImage_Callback(hObject, eventdata, handles)
	ivCalculateImageShift;

function updateComp_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	ivUpdateComposite;


% --- Executes during object creation, after setting all properties.
function tsFileCounter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tsFileCounter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tsFileCounter_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
    global state
	ivFlipTimeSeries(state.imageViewer.tsFileCounter, 1);


% --- Executes during object creation, after setting all properties.
function currentDendriteLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentDendriteLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function currentDendriteLength_Callback(hObject, eventdata, handles)
% hObject    handle to currentDendriteLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentDendriteLength as text
%        str2double(get(hObject,'String')) returns contents of currentDendriteLength as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function triggerTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to triggerTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function triggerTime_Callback(hObject, eventdata, handles)
% hObject    handle to triggerTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of triggerTime as text
%        str2double(get(hObject,'String')) returns contents of triggerTime as a double


