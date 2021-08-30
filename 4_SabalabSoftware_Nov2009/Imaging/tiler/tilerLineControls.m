function varargout = tilerLineControls(varargin)
% TILERLINECONTROLS M-file for tilerLineControls.fig
%      TILERLINECONTROLS, by itself, creates a new TILERLINECONTROLS or raises the existing
%      singleton*.
%
%      H = TILERLINECONTROLS returns the handle to a new TILERLINECONTROLS or the handle to
%      the existing singleton*.
%
%      TILERLINECONTROLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TILERLINECONTROLS.M with the given input arguments.
%
%      TILERLINECONTROLS('Property','Value',...) creates a new TILERLINECONTROLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tilerLineControls_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tilerLineControls_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tilerLineControls

% Last Modified by GUIDE v2.5 16-Feb-2003 15:17:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tilerLineControls_OpeningFcn, ...
                   'gui_OutputFcn',  @tilerLineControls_OutputFcn, ...
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


% --- Executes just before tilerLineControls is made visible.
function tilerLineControls_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tilerLineControls (see VARARGIN)

% Choose default command line output for tilerLineControls
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tilerLineControls wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tilerLineControls_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in mirrorAcq0.
function generic_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	tilerAddInputChannels;

% --- Executes on button press in mirrorAcq1.
function mirrorAcq1_Callback(hObject, eventdata, handles)
% hObject    handle to mirrorAcq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mirrorAcq1


% --- Executes on button press in mirrorAcq2.
function mirrorAcq2_Callback(hObject, eventdata, handles)
% hObject    handle to mirrorAcq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mirrorAcq2


% --- Executes on button press in mirrorAcq3.
function mirrorAcq3_Callback(hObject, eventdata, handles)
% hObject    handle to mirrorAcq3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mirrorAcq3


% --- Executes on button press in physAcq0.
function physAcq0_Callback(hObject, eventdata, handles)
% hObject    handle to physAcq0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of physAcq0


% --- Executes on button press in physAcq1.
function physAcq1_Callback(hObject, eventdata, handles)
% hObject    handle to physAcq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of physAcq1


% --- Executes on button press in physAcq2.
function physAcq2_Callback(hObject, eventdata, handles)
% hObject    handle to physAcq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of physAcq2


% --- Executes on button press in physAcq3.
function physAcq3_Callback(hObject, eventdata, handles)
% hObject    handle to physAcq3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of physAcq3


% --- Executes on button press in physAcq4.
function physAcq4_Callback(hObject, eventdata, handles)
% hObject    handle to physAcq4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of physAcq4


% --- Executes on button press in physAcq5.
function physAcq5_Callback(hObject, eventdata, handles)
% hObject    handle to physAcq5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of physAcq5


% --- Executes on button press in physAcq6.
function physAcq6_Callback(hObject, eventdata, handles)
% hObject    handle to physAcq6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of physAcq6


% --- Executes on button press in physAcq7.
function physAcq7_Callback(hObject, eventdata, handles)
% hObject    handle to physAcq7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of physAcq7


