function varargout = basicConfigurationGUI(varargin)
% BASICCONFIGURATIONGUI_OLD Application M-file for configurationGUI.fig
%    FIG = BASICCONFIGURATIONGUI_OLD launch configurationGUI GUI.
%    BASICCONFIGURATIONGUI_OLD('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 05-Oct-2009 15:43:06

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



% --------------------------------------------------------------------
function varargout = generic_Callback(h, eventdata, handles, varargin)
% Stub for Callback of most uicontrol handles
	global state
	state.internal.configurationChanged=1;
	state.internal.configurationNeedsSaving=1;
	genericCallback(h);

% --------------------------------------------------------------------
function varargout = pixelsPerLine_Callback(h, eventdata, handles, varargin)
% Stub for Callback of most uicontrol handles
	global state
	state.internal.configurationChanged=1;
	state.internal.configurationNeedsSaving=1;
	state.acq.pixelsPerLineGUI = get(h,'Value');
	state.acq.pixelsPerLine = str2num(getMenuEntry(h, state.acq.pixelsPerLineGUI));
	genericCallback(h);
	setAcquisitionParameters;

% --- Executes during object creation, after setting all properties.
function lineDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lineDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function lineDelay_Callback(hObject, eventdata, handles)
% hObject    handle to lineDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lineDelay as text
%        str2double(get(hObject,'String')) returns contents of lineDelay as a double


% --- Executes during object creation, after setting all properties.
function fillFraction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fillFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --------------------------------------------------------------------
function varargout = fillFraction_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.popupmenu2.
	global state 
	state.internal.configurationChanged=1;
	state.internal.configurationNeedsSaving=1;
	genericCallback(h);
	setAcquisitionParameters;
	state.internal.lineDelay = state.acq.lineDelay/state.acq.msPerLine;


% --- Executes during object creation, after setting all properties.
function msPerLine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msPerLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

	
% --------------------------------------------------------------------
function varargout = msPerLine_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.popupmenu1.
	global state

	state.internal.configurationChanged=1;
	state.internal.configurationNeedsSaving=1;
	genericCallback(h);
	setAcquisitionParameters;


% --- Executes during object creation, after setting all properties.
function mirrorLag_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function outputRate_CreateFcn(hObject, eventdata, handles)
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));

function outputRate_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	state.internal.configurationChanged=1;
	state.internal.configurationNeedsSaving=1;
	siApplyDAQSampleRates
	setAcquisitionParameters;	


% --- Executes during object creation, after setting all properties.
function inputRate_CreateFcn(hObject, eventdata, handles)
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));

function inputRate_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	state.internal.configurationChanged=1;
	state.internal.configurationNeedsSaving=1;
	siApplyDAQSampleRates
%	setAcquisitionParameters;	

% --- Executes during object creation, after setting all properties.
function pixelTime_CreateFcn(hObject, eventdata, handles)
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));


% --- Executes during object creation, after setting all properties.
function samplesPerLine_CreateFcn(hObject, eventdata, handles)
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));



% --- Executes during object creation, after setting all properties.
function binFactor_CreateFcn(hObject, eventdata, handles)
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));


% --- Executes during object creation, after setting all properties.
function actualmsPerLine_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function actualmsPerLine_Callback(hObject, eventdata, handles)


function bidi_Callback(hObject, eventdata, handles)
	global state
	state.internal.configurationChanged=1;
	state.internal.configurationNeedsSaving=1;
	genericCallback(hObject);
	setAcquisitionParameters;

function trimImageEdges_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	
	if state.internal.trimImageEdges
		possiblePixelsPerLine={'16', '32', '64', '128', '256', '512', '1024'};
	else
		pixList=allFactors(state.internal.samplesPerLine);
		possiblePixelsPerLine=cell(1, length(pixList));
		for counter=1:length(pixList)
			possiblePixelsPerLine{counter}=num2str(pixList(counter));
		end
	end
	global gh
	set(gh.basicConfigurationGUI.pixelsPerLine, 'String', possiblePixelsPerLine);
	set(gh.basicConfigurationGUI.pixelsPerLine, 'Value', 1);
	pixelsPerLine_Callback(gh.basicConfigurationGUI.pixelsPerLine);
	
function startSampleInLine_Callback(hObject, eventdata, handles)

function startSampleInLine_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function endSampleInLine_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function endSampleInLine_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function actualOutputRate_Callback(hObject, eventdata, handles)

function actualOutputRate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function actualPcellOutputRate_Callback(hObject, eventdata, handles)

function actualPcellOutputRate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function actualInputRate_Callback(hObject, eventdata, handles)

function actualInputRate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
