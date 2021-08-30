function varargout = avgAnalysis(varargin)
% AVGANALYSIS M-file for avgAnalysis.fig
%      AVGANALYSIS, by itself, creates a new AVGANALYSIS or raises the existing
%      singleton*.
%
%      H = AVGANALYSIS returns the handle to a new AVGANALYSIS or the handle to
%      the existing singleton*.
%
%      AVGANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function d CALLBACK in AVGANALYSIS.M with the given input arguments.
%
%      AVGANALYSIS('Property','Value',...) creates a new AVGANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before avgAnalysis_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to avgAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help avgAnalysis

% Last Modified by GUIDE v2.5 30-Jan-2003 11:15:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @avgAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @avgAnalysis_OutputFcn, ...
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


% --- Executes just before avgAnalysis is made visible.
function avgAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to avgAnalysis (see VARARGIN)

% Choose default command line output for avgAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes avgAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = avgAnalysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in avgout.
function avgout_Callback(hObject, eventdata, handles)
% hObject    handle to avgout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	global state gh
	try
		avgout(state.avgAnalysis.components{state.avgAnalysis.currentInList}, state.avgAnalysis.avgName);
		if ishandle(state.avgAnalysis.avgComponentFigure)
			figure(state.avgAnalysis.avgComponentFigure);
			if length(state.avgAnalysis.components)>=state.avgAnalysis.currentInList
				remove(state.avgAnalysis.components{state.avgAnalysis.currentInList});
			end
		end
		
		state.avgAnalysis.components=avgComponentList(state.avgAnalysis.avgName);
		set(gh.avgAnalysis.componentList, 'String', state.avgAnalysis.components);
		state.avgAnalysis.currentInList=1;
		updateGUIByGlobal('state.avgAnalysis.currentInList');
	catch
		disp('avgout_Callback : could not average out :');
		disp([' *** ' lasterr ]);
	end

% --- Executes on button press in avgload.
function avgload_Callback(hObject, eventdata, handles)
% hObject    handle to avgload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	updateForNewAvg;


% --- Executes during object creation, after setting all properties.
function componentList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to componentList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in componentList.
function componentList_Callback(hObject, eventdata, handles)
% hObject    handle to componentList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns componentList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from componentList
	global state
	if ishandle(state.avgAnalysis.avgComponentFigure)
		figure(state.avgAnalysis.avgComponentFigure);
		if length(state.avgAnalysis.components)>=state.avgAnalysis.currentInList
			setPlotProps(state.avgAnalysis.components{state.avgAnalysis.currentInList}, 'Color', 'Blue');
		end
		genericCallback(hObject);
		figure(state.avgAnalysis.avgComponentFigure);
		if length(state.avgAnalysis.components)>=state.avgAnalysis.currentInList
			setPlotProps(state.avgAnalysis.components{state.avgAnalysis.currentInList}, 'Color', 'Red');
		end
	else
		genericCallback(hObject);
		disp('*** componentList_Callback : no figure to update');
	end


% --- Executes during object creation, after setting all properties.
function waveList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waveList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in waveList.
function waveList_Callback(hObject, eventdata, handles)
% hObject    handle to waveList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns waveList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from waveList
	global state
	wList=get(hObject, 'String');
	state.avgAnalysis.avgName=wList{get(hObject, 'Value')};
	updateGUIByGlobal('state.avgAnalysis.avgName');
	updateForNewAvg;
	
% --- Executes on button press in updateWaveList.
function updateWaveList_Callback(hObject, eventdata, handles)
% hObject    handle to updateWaveList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	global gh
	wList=showCurrentWaves;
	set(gh.avgAnalysis.waveList, 'String', wList);
	
% --- Executes on button press in avgin.
function avgin_Callback(hObject, eventdata, handles)
% hObject    handle to avgin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function avgName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avgName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function avgName_Callback(hObject, eventdata, handles)
% hObject    handle to avgName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avgName as text
%        str2double(get(hObject,'String')) returns contents of avgName as a double
	genericCallback(hObject);
	updateForNewAvg;
	
function updateForNewAvg
	global state
	retreiveWave(state.avgAnalysis.avgName);
	if ~iswave(state.avgAnalysis.avgName)
		state.avgAnalysis.avgName='NOT VALID';
		updateGUIByGlobal('state.avgAnalysis.avgName');
	else
		global gh
		state.avgAnalysis.components=avgComponentList(state.avgAnalysis.avgName);
		set(gh.avgAnalysis.componentList, 'String', state.avgAnalysis.components);
		state.avgAnalysis.currentInList=1;
		updateGUIByGlobal('state.avgAnalysis.currentInList');
		evalin('base', ['plot(' state.avgAnalysis.avgName ');']);
		state.avgAnalysis.avgFigure=gcf;
		set(state.avgAnalysis.avgFigure, 'Name', state.avgAnalysis.avgName);
		set(state.avgAnalysis.avgFigure, 'NumberTitle', 'off');
		plotAvgComponents(state.avgAnalysis.avgName);
		state.avgAnalysis.avgComponentFigure=gcf;
		if length(state.avgAnalysis.components)>0
			setPlotProps(state.avgAnalysis.components{1}, 'Color', 'Red');
		end
	end

