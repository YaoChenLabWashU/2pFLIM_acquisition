function varargout = fieldAdjustGUI(varargin)
% FIELDADJUSTGUI M-file for fieldAdjustGUI.fig
%      FIELDADJUSTGUI, by itself, creates a new FIELDADJUSTGUI or raises the existing
%      singleton*.
%
%      H = FIELDADJUSTGUI returns the handle to a new FIELDADJUSTGUI or the handle to
%      the existing singleton*.
%
%      FIELDADJUSTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIELDADJUSTGUI.M with the given input arguments.
%
%      FIELDADJUSTGUI('Property','Value',...) creates a new FIELDADJUSTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fieldAdjustGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fieldAdjustGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fieldAdjustGUI

% Last Modified by GUIDE v2.5 15-Sep-2009 16:46:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fieldAdjustGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @fieldAdjustGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before fieldAdjustGUI is made visible.
function fieldAdjustGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fieldAdjustGUI (see VARARGIN)

% Choose default command line output for fieldAdjustGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fieldAdjustGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fieldAdjustGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in preRotRight.
function preRotRight_Callback(hObject, eventdata, handles)
% hObject    handle to preRotRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	global state
	state.acq.postRotOffsetX = state.acq.postRotOffsetX ...
		+ cos(state.acq.scanRotation*pi/180) * state.acq.scanAmplitudeX * (-1 * state.acq.preStep/state.acq.zoomFactor);
	state.acq.postRotOffsetY = state.acq.postRotOffsetY ...
		- sin(state.acq.scanRotation*pi/180) * state.acq.scanAmplitudeX * (-1 * state.acq.preStep/state.acq.zoomFactor);
	updateHeaderString('state.acq.postRotOffsetX');
	updateHeaderString('state.acq.postRotOffsetY');
    updateNavigator;
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end
%	set(hObject, 'Enable', 'on');


% --- Executes on button press in preRotLeft.
function preRotLeft_Callback(hObject, eventdata, handles)
% hObject    handle to preRotLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	global state
	state.acq.postRotOffsetX = state.acq.postRotOffsetX ...
		+ cos(state.acq.scanRotation*pi/180) * state.acq.scanAmplitudeX * (state.acq.preStep/state.acq.zoomFactor);
	state.acq.postRotOffsetY = state.acq.postRotOffsetY ...
		- sin(state.acq.scanRotation*pi/180) * state.acq.scanAmplitudeX * (state.acq.preStep/state.acq.zoomFactor);
	updateHeaderString('state.acq.postRotOffsetX');
	updateHeaderString('state.acq.postRotOffsetY');
    updateNavigator;
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end

% 	set(hObject, 'Enable', 'on');


% --- Executes on button press in preRotUp.
function preRotUp_Callback(hObject, eventdata, handles)
% hObject    handle to preRotUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	global state
	state.acq.postRotOffsetX = state.acq.postRotOffsetX ...
		+ sin(state.acq.scanRotation*pi/180) * state.acq.scanAmplitudeY * (state.acq.preStep/state.acq.zoomFactor);
	state.acq.postRotOffsetY = state.acq.postRotOffsetY ...
		+ cos(state.acq.scanRotation*pi/180) * state.acq.scanAmplitudeY * (state.acq.preStep/state.acq.zoomFactor);
 	updateHeaderString('state.acq.postRotOffsetX');
	updateHeaderString('state.acq.postRotOffsetY');
    updateNavigator;
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end

	set(hObject, 'Enable', 'on');


% --- Executes on button press in preRotDown.
function preRotDown_Callback(hObject, eventdata, handles)
% hObject    handle to preRotDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	global state
	state.acq.postRotOffsetX = state.acq.postRotOffsetX ...
		+ sin(state.acq.scanRotation*pi/180) * state.acq.scanAmplitudeY * (-1 * state.acq.preStep/state.acq.zoomFactor);
	state.acq.postRotOffsetY = state.acq.postRotOffsetY ...
		+ cos(state.acq.scanRotation*pi/180) * state.acq.scanAmplitudeY * (-1 * state.acq.preStep/state.acq.zoomFactor);
	updateHeaderString('state.acq.postRotOffsetX');
	updateHeaderString('state.acq.postRotOffsetY');
    updateNavigator;
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end

	set(hObject, 'Enable', 'on');
	

% --- Executes on button press in preRotReset.
function preRotReset_Callback(hObject, eventdata, handles)
% hObject    handle to preRotReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	global state
	state.acq.postRotOffsetX = 0;
	state.acq.postRotOffsetY = 0;
	updateHeaderString('state.acq.postRotOffsetX');
	updateHeaderString('state.acq.postRotOffsetY');
     updateNavigator;
   try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end

	set(hObject, 'Enable', 'on');
	



% --- Executes during object creation, after setting all properties.
function mainZoomSlider_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function mainZoomSlider_Callback(hObject, eventdata, handles)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	genericCallback(hObject);
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end

	set(hObject, 'Enable', 'on');

% --- Executes during object creation, after setting all properties.
function mainZoom_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function mainZoom_Callback(hObject, eventdata, handles)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	genericCallback(hObject);
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end

	set(hObject, 'Enable', 'on');

% --- Executes during object creation, after setting all properties.
function scanRotationSlider_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function scanRotationSlider_Callback(hObject, eventdata, handles)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	genericCallback(hObject);
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end
	set(hObject, 'Enable', 'on');

% --- Executes during object creation, after setting all properties.
function scanRotation_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function scanRotation_Callback(hObject, eventdata, handles)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	genericCallback(hObject);
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end
	set(hObject, 'Enable', 'on');


% --- Executes on button press in resetAllButton.
function resetAllButton_Callback(hObject, eventdata, handles)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	global state
	state.acq.zoomFactor=1;
	state.acq.scanRotation = 0;
	state.acq.postRotOffsetX = 0;
	state.acq.postRotOffsetY = 0;
	state.acq.preRotOffsetX = 0;
	state.acq.preRotOffsetY = 0;
	state.acq.lineScan=0;
	updateGUIByGlobal('state.acq.zoomFactor');
	updateGUIByGlobal('state.acq.scanRotation');
	updateGUIByGlobal('state.acq.lineScan');
	updateHeaderString('state.acq.postRotOffsetX');
	updateHeaderString('state.acq.postRotOffsetY');
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end
	set(hObject, 'Enable', 'on');
	
% --- Executes on button press in lineScanCB.
function lineScanCB_Callback(hObject, eventdata, handles)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	genericCallback(hObject);
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end
	set(hObject, 'Enable', 'on');

% --- Executes during object creation, after setting all properties.
function postStep_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function postStep_Callback(hObject, eventdata, handles)
	genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function preStep_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function preStep_Callback(hObject, eventdata, handles)
	genericCallback(hObject);


% --- Executes on button press in focusButton.
function focusButton_Callback(hObject, eventdata, handles)
	executeFocusCallback;


% --- Executes during object creation, after setting all properties.
function fieldSizeX_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function fieldSizeX_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function fieldSizeY_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function fieldSizeY_Callback(hObject, eventdata, handles)


% --- Executes on button press in centerLineButton.
function centerLineButton_Callback(hObject, eventdata, handles)
	global state
	saveCurrentSettings;
	if (state.internal.status==2) || (state.internal.status==3)
		return
	end
%	set(hObject, 'Enable', 'off');
	try
		setStatusString('Click line ends');
		siSelectionChannelToFront

		[x,y]=ginput(2);
		if size(x,1)~=2
			return
		end
	

		index = round(mean(y)-1) * state.internal.lengthOfXData + ...
			round(state.internal.lengthOfXData*...
			(state.internal.fractionStart+mean(x)*state.internal.fractionPerPixel));
			
		% slide center over
        state.acq.postRotOffsetX = (state.acq.repeatedMirrorData(index,1) - state.acq.scanOffsetX);
		state.acq.postRotOffsetY = (state.acq.repeatedMirrorData(index,2) - state.acq.scanOffsetY);
		
		% calculate angle
	    state.acq.scanRotation = state.acq.scanRotation - atan2((y(2)-y(1)), (x(2)-x(1)))*180/pi;
        if (state.acq.scanRotation<-180)
			state.acq.scanRotation=state.acq.scanRotation+360;
		elseif (state.acq.scanRotation>180)
			state.acq.scanRotation=state.acq.scanRotation-360;
		end
		state.acq.scanRotation=round(state.acq.scanRotation*10)/10;
        updateGUIByGlobal('state.acq.scanRotation');
		
        try
            handleScanChange;
        catch
            disp(['*** ERROR in handleScanChange: ' lasterr]);
        end
	catch
 		disp(['*** ERROR in selection: ' lasterr]);
	end		
	set(hObject, 'Enable', 'on');
	setStatusString('');
	

% --- Executes on button press in centerButton.
function centerButton_Callback(hObject, eventdata, handles)
	global state
	saveCurrentSettings;
	if state.internal.status==2 | state.internal.status==3
		return
	end
%	set(hObject, 'Enable', 'off');
	try
		setStatusString('Click image center');
		siSelectionChannelToFront

		[x,y]=ginput(1);
		if isempty(findobj(gcf, 'Type', 'axes'))
			disp('*** NO axes***');
			set(hObject, 'Enable', 'on');	
			return
		end
	
		index = round(y-1) * state.internal.lengthOfXData + round(state.internal.lengthOfXData*(state.internal.fractionStart+x*state.internal.fractionPerPixel));
	
        state.acq.postRotOffsetX = (state.acq.repeatedMirrorData(index,1) - state.acq.scanOffsetX);
		state.acq.postRotOffsetY = (state.acq.repeatedMirrorData(index,2) - state.acq.scanOffsetY);
        try
            handleScanChange;
        catch
            disp(['*** ERROR in handleScanChange: ' lasterr]);
        end
	catch
 		disp(['*** ERROR in selection: ' lasterr]);
	end		

	set(hObject, 'Enable', 'on');
	setStatusString('');
	
% --- Executes on button press in centerButton.
function moveButton_Callback(hObject, eventdata, handles)
	global state

	try
		setStatusString('Click on center');
		siSelectionChannelToFront

		[x,y]=ginput(1);
		if isempty(findobj(gcf, 'Type', 'axes'))
			disp('*** NO axes***');
			set(hObject, 'Enable', 'on');	
			return
		end
	
		index = round(y-1) * state.internal.lengthOfXData + round(state.internal.lengthOfXData*(state.internal.fractionStart+x*state.internal.fractionPerPixel));
	
  		shiftX = (state.acq.repeatedMirrorData(index,1) - state.acq.scanOffsetX) ...
			* state.internal.unitFieldSizeX * state.internal.definingObjective/state.internal.currentObjective;
		shiftY = (state.acq.repeatedMirrorData(index,2) - state.acq.scanOffsetY) ...
			* state.internal.unitFieldSizeY * state.internal.definingObjective/state.internal.currentObjective;
		pos=updateMotorPosition(0);
		
		setMotorPosition(pos+[shiftX shiftY 0]);
		updateRelativeMotorPosition;
	catch
 		disp(['*** ERROR in selection: ' lasterr]);
	end			

% --- Executes on button press in zoomInButton.
function zoomInButton_Callback(hObject, eventdata, handles)
% hObject    handle to zoomInButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
    global state
    state.acq.zoomFactor=max(state.acq.zoomFactor/1.2,0.5);
    updateGUIByGlobal('state.acq.zoomFactor');
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end

	set(hObject, 'Enable', 'on');


% --- Executes on button press in zoomOutButton.
function zoomOutButton_Callback(hObject, eventdata, handles)
% hObject    handle to zoomOutButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	global state
    state.acq.zoomFactor=state.acq.zoomFactor*1.2;
    updateGUIByGlobal('state.acq.zoomFactor');    
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end

	set(hObject, 'Enable', 'on');


% --- Executes on button press in undoButton.
function undoButton_Callback(hObject, eventdata, handles)
% hObject    handle to undoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%	set(hObject, 'Enable', 'off');
	global state
	if length(state.internal.oldFieldSettings)==4
		state.acq.zoomFactor = state.internal.oldFieldSettings(1);
		state.acq.scanRotation = state.internal.oldFieldSettings(2);
		state.acq.postRotOffsetX = state.internal.oldFieldSettings(3);
		state.acq.postRotOffsetY = state.internal.oldFieldSettings(4);
		updateGUIByGlobal('state.acq.scanRotation');
		updateGUIByGlobal('state.acq.zoomFactor');
        try
            handleScanChange;
        catch
            disp(['*** ERROR in handleScanChange: ' lasterr]);
        end

	end
	set(hObject, 'Enable', 'on');

function saveCurrentSettings
	global state
	state.internal.oldFieldSettings=[state.acq.zoomFactor state.acq.scanRotation state.acq.postRotOffsetX state.acq.postRotOffsetY];


% --- Executes during object creation, after setting all properties.
function selectionChannel_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in selectionChannel.
function selectionChannel_Callback(hObject, eventdata, handles)
	genericCallback(hObject);


% --- Executes on button press in zeroRotation.
function zeroRotation_Callback(hObject, eventdata, handles)
%	set(hObject, 'Enable', 'off');
	saveCurrentSettings;
	global state
	state.acq.scanRotation = 0;
	updateGUIByGlobal('state.acq.scanRotation');
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end
	set(hObject, 'Enable', 'on');

function handleScanChange		% call only routines to rotate output
	global state
	state.internal.needNewRotatedMirrorOutput=1;
	applyChangesToOutput;

function autoTrack_Callback(hObject, eventdata, handles)
	genericCallback(hObject);

function setReference_Callback(hObject, eventdata, handles)
	global state
	if state.internal.status==2 | state.internal.status==3
		disp('*** STOP IMAGING FIRST ***');
		return
	else
		setTrackerReference;
	end

function maxShift_Callback(hObject, eventdata, handles)
	genericCallback(hObject);


function trackerChannel_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	updateReferenceImage;


% --- Executes on button press in zoom1.
function zoom1_Callback(hObject, eventdata, handles)
	saveCurrentSettings;
	try
		global state
		state.acq.zoomFactor=1;
 		updateGUIByGlobal('state.acq.zoomFactor');		
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end


% --- Executes on button press in zoom5.
function zoom5_Callback(hObject, eventdata, handles)
	saveCurrentSettings;
	try
		global state
		state.acq.zoomFactor=5;
  		updateGUIByGlobal('state.acq.zoomFactor');		
      	handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end


% --- Executes on button press in zoom10.
function zoom10_Callback(hObject, eventdata, handles)
	saveCurrentSettings;
	try
		global state
		state.acq.zoomFactor=10;
 		updateGUIByGlobal('state.acq.zoomFactor');		
     	handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end


% --- Executes on button press in zoom30.
function zoom30_Callback(hObject, eventdata, handles)
	saveCurrentSettings;
	try
		global state
		state.acq.zoomFactor=30;
		updateGUIByGlobal('state.acq.zoomFactor');		
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end


% --- Executes on button press in zoom35.
function zoom35_Callback(hObject, eventdata, handles)
	saveCurrentSettings;
	try
		global state
		state.acq.zoomFactor=35;
		updateGUIByGlobal('state.acq.zoomFactor');		
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
    end




function sliceShift_Callback(hObject, eventdata, handles)
% hObject    handle to sliceShift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sliceShift as text
%        str2double(get(hObject,'String')) returns contents of sliceShift as a double


% --- Executes during object creation, after setting all properties.
function sliceShift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliceShift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function piezoZslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to piezoZslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function piezoZ_Callback(hObject, eventdata, handles)
% hObject    handle to piezoZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of piezoZ as text
%        str2double(get(hObject,'String')) returns contents of piezoZ as a double
	genericCallback(hObject);
	global state
	set(hObject, 'Enable', 'off');
	if state.piezo.usePiezo
		piezoUpdatePosition;
	end;
	set(hObject, 'Enable', 'on');

% --- Executes during object creation, after setting all properties.
function piezoZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to piezoZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function mirrorLag_Callback(hObject, eventdata, handles)
% hObject    handle to mirrorLag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mirrorLag as text
%        str2double(get(hObject,'String')) returns contents of mirrorLag as a double
	genericCallback(hObject);
	setAcquisitionParameters

% --- Executes during object creation, after setting all properties.
function mirrorLag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mirrorLag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function mirrorLagSlider_Callback(hObject, eventdata, handles)
% hObject    handle to mirrorLagSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
	genericCallback(hObject);
	setAcquisitionParameters

% --- Executes during object creation, after setting all properties.
function mirrorLagSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mirrorLagSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in rotateTo90.
function rotateTo90_Callback(hObject, eventdata, handles)
% hObject    handle to rotateTo90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	saveCurrentSettings;
	global state
	state.acq.scanRotation = 90;
	updateGUIByGlobal('state.acq.scanRotation');
    try
        handleScanChange;
    catch
        disp(['*** ERROR in handleScanChange: ' lasterr]);
	end

	
