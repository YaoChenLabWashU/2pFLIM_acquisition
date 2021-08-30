function varargout = imageTracker(varargin)
% IMAGETRACKER M-file for imageTracker.fig
%      IMAGETRACKER, by itself, creates a new IMAGETRACKER or raises the existing
%      singleton*.
%
%      H = IMAGETRACKER returns the handle to a new IMAGETRACKER or the handle to
%      the existing singleton*.
%
%      IMAGETRACKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGETRACKER.M with the given input arguments.
%
%      IMAGETRACKER('Property','Value',...) creates a new IMAGETRACKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageTracker_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageTracker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageTracker

% Last Modified by GUIDE v2.5 13-Jan-2003 10:01:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageTracker_OpeningFcn, ...
                   'gui_OutputFcn',  @imageTracker_OutputFcn, ...
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


% --- Executes just before imageTracker is made visible.
function imageTracker_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imageTracker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imageTracker_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function trackerChannel_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function maxShift_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function shiftX_CreateFcn(hObject, eventdata, handles)
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));

function shiftY_CreateFcn(hObject, eventdata, handles)
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));

function pixelShiftX_CreateFcn(hObject, eventdata, handles)
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));

function pixelShiftY_CreateFcn(hObject, eventdata, handles)
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));

function setReference_Callback(hObject, eventdata, handles)
	setTrackerReference;
	
function generic_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	updateReferenceImage;
