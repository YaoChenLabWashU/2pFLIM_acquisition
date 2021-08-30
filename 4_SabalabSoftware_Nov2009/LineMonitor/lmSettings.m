function varargout = lmSettings(varargin)
% LMSETTINGS M-file for lmSettings.fig
%      LMSETTINGS, by itself, creates a new LMSETTINGS or raises the existing
%      singleton*.
%
%      H = LMSETTINGS returns the handle to a new LMSETTINGS or the handle to
%      the existing singleton*.
%
%      LMSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LMSETTINGS.M with the given input arguments.
%
%      LMSETTINGS('Property','Value',...) creates a new LMSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lmSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lmSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lmSettings

% Last Modified by GUIDE v2.5 02-Nov-2009 15:45:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lmSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @lmSettings_OutputFcn, ...
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


% --- Executes just before lmSettings is made visible.
function lmSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lmSettings (see VARARGIN)

% Choose default command line output for lmSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lmSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lmSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function changed_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	
	
function rebuild_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	lmBuildDAQs
	


% --- Executes on button press in readNowButton.
function readNowButton_Callback(hObject, eventdata, handles)
	lmReadDAQs



function sigDigits2_Callback(hObject, eventdata, handles)
% hObject    handle to sigDigits2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigDigits2 as text
%        str2double(get(hObject,'String')) returns contents of sigDigits2 as a double


% --- Executes during object creation, after setting all properties.
function sigDigits2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigDigits2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sigDigits3_Callback(hObject, eventdata, handles)
% hObject    handle to sigDigits3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigDigits3 as text
%        str2double(get(hObject,'String')) returns contents of sigDigits3 as a double


% --- Executes during object creation, after setting all properties.
function sigDigits3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigDigits3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sigDigits4_Callback(hObject, eventdata, handles)
% hObject    handle to sigDigits4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigDigits4 as text
%        str2double(get(hObject,'String')) returns contents of sigDigits4 as a double


% --- Executes during object creation, after setting all properties.
function sigDigits4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigDigits4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sigDigits5_Callback(hObject, eventdata, handles)
% hObject    handle to sigDigits5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigDigits5 as text
%        str2double(get(hObject,'String')) returns contents of sigDigits5 as a double


% --- Executes during object creation, after setting all properties.
function sigDigits5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigDigits5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sigDigits6_Callback(hObject, eventdata, handles)
% hObject    handle to sigDigits6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigDigits6 as text
%        str2double(get(hObject,'String')) returns contents of sigDigits6 as a double


% --- Executes during object creation, after setting all properties.
function sigDigits6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigDigits6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sigDigits1_Callback(hObject, eventdata, handles)
% hObject    handle to sigDigits1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigDigits1 as text
%        str2double(get(hObject,'String')) returns contents of sigDigits1 as a double


% --- Executes during object creation, after setting all properties.
function sigDigits1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigDigits1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resizeButton.
function resizeButton_Callback(hObject, eventdata, handles)
% hObject    handle to resizeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gh
if strcmp(get(hObject, 'String'), '>')
	p=get(gh.lmSettings.figure1, 'Position');
	p(3)=91.3;
	set(gh.lmSettings.figure1, 'Position', p);
	set(hObject, 'String', '<');
else
	p=get(gh.lmSettings.figure1, 'Position');
	p(3)=26;
	set(gh.lmSettings.figure1, 'Position', p);
	set(hObject, 'String', '>');
end	

	


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
