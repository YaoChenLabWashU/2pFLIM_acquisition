
function varargout = ivAnalysisSettings(varargin)
% IVANALYSISSETTINGS M-file for ivAnalysisSettings.fig
%      IVANALYSISSETTINGS, by itself, creates a new IVANALYSISSETTINGS or raises the existing
%      singleton*.
%
%      H = IVANALYSISSETTINGS returns the handle to a new IVANALYSISSETTINGS or the handle to
%      the existing singleton*.
%
%      IVANALYSISSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IVANALYSISSETTINGS.M with the given input arguments.
%
%      IVANALYSISSETTINGS('Property','Value',...) creates a new IVANALYSISSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ivAnalysisSettings_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ivAnalysisSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ivAnalysisSettings

% Last Modified by GUIDE v2.5 09-Aug-2006 15:05:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ivAnalysisSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @ivAnalysisSettings_OutputFcn, ...
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


% --- Executes just before ivAnalysisSettings is made visible.
function ivAnalysisSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ivAnalysisSettings (see VARARGIN)

% Choose default command line output for ivAnalysisSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ivAnalysisSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ivAnalysisSettings_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function generic_Callback(hObject, eventdata, handles)
	genericCallback(hObject);

function text_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	state.imageViewer.objStructs(state.imageViewer.currentObject).text  = state.imageViewer.currentObjectText;
	
function ivSetChannelIndex_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	ivSetChannelIndex;

function recalc_Callback(hObject, eventdata, handles)
	global state
	ivDefineObjectAxes(1)
	
function recalcAll_Callback(hObject, eventdata, handles)
	global state
	if ~isempty(state.imageViewer.definedLines)
		for counter=1:size(state.imageViewer.definedLines, 1)
			state.imageViewer.currentSelection=counter;
			updateGUIByGlobal('state.imageViewer.currentSelection');
			ivUpdateSelCoords;
			ivAnalyzeFluor(...
				state.imageViewer.definedLines(state.imageViewer.currentSelection, 1:2)', ...
				state.imageViewer.definedLines(state.imageViewer.currentSelection, 3:4)');
		end
	end
	
function deleteSelection_Callback(hObject, eventdata, handles)
	global state
	if ~isempty(state.imageViewer.definedLines)
		if state.imageViewer.currentSelection>0 & state.imageViewer.currentSelection<=length(state.imageViewer.definedLines)
			if ishandle(state.imageViewer.lineHandles(state.imageViewer.currentSelection))
				delete(state.imageViewer.lineHandles(state.imageViewer.currentSelection));
			end
			if ishandle(state.imageViewer.lineHandles(state.imageViewer.currentSelection))
				delete(state.imageViewer.lineHandlesRef(state.imageViewer.currentSelection));
			end
			state.imageViewer.lineHandles(state.imageViewer.currentSelection)=[];
			state.imageViewer.lineHandlesRef(state.imageViewer.currentSelection)=[];
			state.imageViewer.definedLines(state.imageViewer.currentSelection, :)=[];
			state.imageViewer.currentSelection=min(state.imageViewer.currentSelection, length(state.imageViewer.definedLines));
			updateGUIByGlobal('state.imageViewer.currentSelection');
			ivUpdateSelectionDisplay;	
		end
	end
	
function deleteAllSelections_Callback(hObject, eventdata, handles)
	global state
	state.imageViewer.definedLines=[];
	for counter=1:length(state.imageViewer.lineHandles)
		try
			delete(state.imageViewer.lineHandles(counter));
		catch
		end
		try
			delete(state.imageViewer.lineHandlesRef(counter));
		catch
		end
	end
	state.imageViewer.lineHandles=[];
	state.imageViewer.lineHandlesRef=[];
	state.imageViewer.currentSelection=0;
	updateGUIByGlobal('state.imageViewer.currentSelection');
	
function currentSelection_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	ivUpdateSelectionDisplay;
	ivUpdateSelCoords;

function redrawSelection_Callback(hObject, eventdata, handles)
	if nargin>0
		genericCallback(hObject);
	end
	global state
	if ~isempty(state.imageViewer.definedLines)
		if state.imageViewer.currentSelection>0 & state.imageViewer.currentSelection<=length(state.imageViewer.definedLines)
			x=[state.imageViewer.selX0 state.imageViewer.selX1];
			y=[state.imageViewer.selY0 state.imageViewer.selY1];
			state.imageViewer.definedLines(state.imageViewer.currentSelection, :)=[x y];
			if state.imageViewer.analyzeBox
				x2=[x(1) x(2) x(2) x(1) x(1)]';
				y2=[y(1) y(1) y(2) y(2) y(1)]';
				set(state.imageViewer.lineHandles(state.imageViewer.currentSelection), ...
					'XData', x2+state.imageViewer.pixelShiftX, 'YData', y2+state.imageViewer.pixelShiftY);
				set(state.imageViewer.lineHandlesRef(state.imageViewer.currentSelection), ...
					'XData', x2, 'YData', y2);
			else
				set(state.imageViewer.lineHandles(state.imageViewer.currentSelection), ...
					'XData', x', 'YData', y');
				set(state.imageViewer.lineHandlesRef(state.imageViewer.currentSelection), ...
					'XData', x'+state.imageViewer.pixelShiftX, 'YData', y'+state.imageViewer.pixelShiftY);
			end
		end
	end
	
function moveSelUp_Callback(hObject, eventdata, handles)
	global state
	state.imageViewer.selY0=state.imageViewer.selY0-1;
	state.imageViewer.selY1=state.imageViewer.selY1-1;
	updateGUIByGlobal('state.imageViewer.selY0');
	updateGUIByGlobal('state.imageViewer.selY1');
	redrawSelection_Callback;
	
function moveSelDown_Callback(hObject, eventdata, handles)
	global state
	state.imageViewer.selY0=state.imageViewer.selY0+1;
	state.imageViewer.selY1=state.imageViewer.selY1+1;
	updateGUIByGlobal('state.imageViewer.selY0');
	updateGUIByGlobal('state.imageViewer.selY1');
	redrawSelection_Callback;

function moveSelRight_Callback(hObject, eventdata, handles)
	global state
	state.imageViewer.selX0=state.imageViewer.selX0+1;
	state.imageViewer.selX1=state.imageViewer.selX1+1;
	updateGUIByGlobal('state.imageViewer.selX0');
	updateGUIByGlobal('state.imageViewer.selX1');
	redrawSelection_Callback;
	
function moveSelLeft_Callback(hObject, eventdata, handles)
	global state
	state.imageViewer.selX0=state.imageViewer.selX0-1;
	state.imageViewer.selX1=state.imageViewer.selX1-1;
	updateGUIByGlobal('state.imageViewer.selX0');
	updateGUIByGlobal('state.imageViewer.selX1');
	redrawSelection_Callback;



function currentObject_Callback(hObject, eventdata, handles)
	genericCallback(hObject);	
	ivHighlightObject;

function objectShowTraces_Callback(hObject, eventdata, handles)
	genericCallback(hObject);	
	global state
	if state.imageViewer.objectShowTraces
		ivSeeObjectTraces;
	else
		ivHideObjectTraces;
	end		


% --- Executes on button press in objectAutoCenter.
function objectAutoCenter_Callback(hObject, eventdata, handles)
	genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function objectStatus_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in objectStatus.
function objectStatus_Callback(hObject, eventdata, handles)
	genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function analysisMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analysisMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in analysisMode.
function analysisMode_Callback(hObject, eventdata, handles)
% hObject    handle to analysisMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns analysisMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from analysisMode


% --- Executes during object creation, after setting all properties.
function projectionmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectionmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in projectionmode.
function projectionmode_Callback(hObject, eventdata, handles)
% hObject    handle to projectionmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns projectionmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from projectionmode


% --- Executes during object creation, after setting all properties.
function projectionMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectionMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in projectionMode.
function projectionMode_Callback(hObject, eventdata, handles)
% hObject    handle to projectionMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns projectionMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from projectionMode


% --- Executes on button press in autoSetBoxPeak.
function autoSetBoxPeak_Callback(hObject, eventdata, handles)
% hObject    handle to autoSetBoxPeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoSetBoxPeak


% --- Executes on button press in autoSetSpineStart.
function autoSetSpineStart_Callback(hObject, eventdata, handles)
% hObject    handle to autoSetSpineStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoSetSpineStart


% --- Executes during object creation, after setting all properties.
function spineStartThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spineStartThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function spineStartThresh_Callback(hObject, eventdata, handles)
% hObject    handle to spineStartThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spineStartThresh as text
%        str2double(get(hObject,'String')) returns contents of spineStartThresh as a double


% --- Executes during object creation, after setting all properties.
function spineStartThreshSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spineStartThreshSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function spineStartThreshSlider_Callback(hObject, eventdata, handles)
% hObject    handle to spineStartThreshSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


