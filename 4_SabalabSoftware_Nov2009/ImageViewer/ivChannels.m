function varargout = ivChannels(varargin)
% IVCHANNELS M-file for ivChannels.fig
%      IVCHANNELS, by itself, creates a new IVCHANNELS or raises the existing
%      singleton*.
%
%      H = IVCHANNELS returns the handle to a new IVCHANNELS or the handle to
%      the existing singleton*.
%
%      IVCHANNELS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IVCHANNELS.M with the given input arguments.
%
%      IVCHANNELS('Property','Value',...) creates a new IVCHANNELS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ivChannels_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ivChannels_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ivChannels

% Last Modified by GUIDE v2.5 08-Mar-2006 09:50:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ivChannels_OpeningFcn, ...
                   'gui_OutputFcn',  @ivChannels_OutputFcn, ...
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


% --- Executes just before ivChannels is made visible.
function ivChannels_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ivChannels (see VARARGIN)

% Choose default command line output for ivChannels
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ivChannels wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ivChannels_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in data1.
function generic_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	tagName=get(hObject, 'Tag');
	tagNum=str2num(tagName(end-1:end));
	if isempty(tagNum)
		tagNum=str2num(tagName(end));
		tagStub=tagName(1:end-1);
	else
		tagStub=tagName(1:end-2);
	end
	eval(['state.imageViewer.' tagStub 'Channels(tagNum)=state.imageViewer.' tagName ';']);
	if strcmp('view', tagStub)
		ivUpdateVisibleWindows
	end
	ivSetValidAnaChannels;
