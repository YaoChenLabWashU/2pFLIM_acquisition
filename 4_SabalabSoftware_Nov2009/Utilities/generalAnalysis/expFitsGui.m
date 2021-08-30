function varargout = expFitsGui(varargin)
% EXPFITSGUI M-file for expFitsGui.fig
%      EXPFITSGUI, by itself, creates a new EXPFITSGUI or raises the existing
%      singleton*.
%
%      H = EXPFITSGUI returns the handle to a new EXPFITSGUI or the handle to
%      the existing singleton*.
%
%      EXPFITSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPFITSGUI.M with the given input arguments.
%
%      EXPFITSGUI('Property','Value',...) creates a new EXPFITSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before expFitsGui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to expFitsGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help expFitsGui

% Last Modified by GUIDE v2.5 20-Mar-2003 16:06:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @expFitsGui_OpeningFcn, ...
                   'gui_OutputFcn',  @expFitsGui_OutputFcn, ...
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


% --- Executes just before expFitsGui is made visible.
function expFitsGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to expFitsGui (see VARARGIN)

% Choose default command line output for expFitsGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes expFitsGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = expFitsGui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function acqNumber_Callback(hObject, eventdata, handles)
% hObject    handle to acqNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of acqNumber as text
%        str2double(get(hObject,'String')) returns contents of acqNumber as a double
	genericCallback(hObject);
	applySelection



function roiNumber_Callback(hObject, eventdata, handles)
% hObject    handle to roiNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roiNumber as text
%        str2double(get(hObject,'String')) returns contents of roiNumber as a double
	genericCallback(hObject);
	applySelection





function x0_Callback(hObject, eventdata, handles)
% hObject    handle to x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x0 as text
%        str2double(get(hObject,'String')) returns contents of x0 as a double



function x1_Callback(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x1 as text
%        str2double(get(hObject,'String')) returns contents of x1 as a double



function amp_Callback(hObject, eventdata, handles)
% hObject    handle to amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amp as text
%        str2double(get(hObject,'String')) returns contents of amp as a double



function tau_Callback(hObject, eventdata, handles)
% hObject    handle to tau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau as text
%        str2double(get(hObject,'String')) returns contents of tau as a double


% --- Executes on button press in selectAndFit.
function selectAndFit_Callback(hObject, eventdata, handles)
% hObject    handle to selectAndFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	global state
	[a, t, t2]=selectAndFit(state.expFits.figure);
	state.expFits.amp=a;
	state.expFits.tau=t;
	xData=makeXData('display_expFit');
	state.expFits.x0=xData(1);
	state.expFits.x1=xData(end);
	updateGUIByGlobal('state.expFits.amp');
	updateGUIByGlobal('state.expFits.tau');
	updateGUIByGlobal('state.expFits.x0');
	updateGUIByGlobal('state.expFits.x1');

	global expFit_tau expFit_amp expFit_tau2
	expFit_tau2(state.expFits.acqNumber)=t2;
	expFit_tau(state.expFits.acqNumber)=t;
	expFit_amp(state.expFits.acqNumber)=a;
	
	
function applySelection
	global state
	
	
	set('display_exp', 'data', []);
	set('display_expFit', 'data', []);
	set('display_expRange', 'data', []);

	if ~iswave(ROIScanName(1, state.expFits.roiNumber, state.expFits.acqNumber))
		try
			reviewFluorData(state.expFits.acqNumber, 1);
		catch
			lasterr
			beep
			disp('COULD NOT LOAD DATA');
		end
	end
	if iswave(ROIScanName(1, state.expFits.roiNumber, state.expFits.acqNumber))
		duplicateo(ROIScanName(1, state.expFits.roiNumber, state.expFits.acqNumber), 'display_exp');
 		global display_exp
 		display_exp.data=smooth(display_exp.data-mean(display_exp.data(20:50)),5);
	end
