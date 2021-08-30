function varargout = chooser(varargin)
% CHOOSER M-file for chooser.fig
%      CHOOSER, by itself, creates a new CHOOSER or raises the existing
%      singleton*.
%
%      H = CHOOSER returns the handle to a new CHOOSER or the handle to
%      the existing singleton*.
%
%      CHOOSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHOOSER.M with the given input arguments.
%
%      CHOOSER('Property','Value',...) creates a new CHOOSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chooser_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chooser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chooser

% Last Modified by GUIDE v2.5 14-Jul-2003 13:27:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chooser_OpeningFcn, ...
                   'gui_OutputFcn',  @chooser_OutputFcn, ...
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


% --- Executes just before chooser is made visible.
function chooser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chooser (see VARARGIN)

% Choose default command line output for chooser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes chooser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = chooser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in matlab.
function matlab_Callback(hObject, eventdata, handles)
% hObject    handle to matlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	hideGUI('gh.chooser.figure1');

% --- Executes on button press in imaging.
function imaging_Callback(hObject, eventdata, handles)
% hObject    handle to imaging (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	hideGUI('gh.chooser.figure1');
    global state
	initTimer(state.analysisMode, {'Imaging', 'LineMonitor'});


% --- Executes on button press in phys.
function phys_Callback(hObject, eventdata, handles)
% hObject    handle to phys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	hideGUI('gh.chooser.figure1');
    global state
	initTimer(state.analysisMode, {'Physiology', 'LineMonitor'});
	

% --- Executes on button press in both.
function both_Callback(hObject, eventdata, handles)
% hObject    handle to both (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	hideGUI('gh.chooser.figure1');
    global state
	initTimer(state.analysisMode, {'Imaging', 'Physiology', 'LineMonitor'});


