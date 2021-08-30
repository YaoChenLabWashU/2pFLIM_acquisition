function varargout = physcontrols(varargin)
% PHYSCONTROLS Application M-file for physControls.fig
%    FIG = PHYSCONTROLS launch physControls GUI.
%    PHYSCONTROLS('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 27-Oct-2009 11:18:18

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
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
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
function varargout = startButton_Callback(h, eventdata, handles, varargin)
	phGrabButtonPressed;

% --------------------------------------------------------------------
function varargout = FileMenu_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = SettingsMenu_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = generic_Callback(h, eventdata, handles, varargin)
	genericCallback(h);


% --------------------------------------------------------------------
function varargout = changedPulse_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	state.phys.internal.needNewOutputData=1;
	phCheckAcquisitionChannels

% --------------------------------------------------------------------
function varargout = gains_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	% force update of pulses when the gains are changed
	state.phys.internal.needNewOutputData=1;

% --------------------------------------------------------------------
function varargout = popupmenu1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = externalTrigger_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = timer_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = review_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	reviewPhysAcq;

function varargout = currentClamp0_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	if state.phys.settings.currentClamp0
		setCurrentClamp(0);
	else
		setVoltageClamp(0);
	end

function varargout = currentClamp1_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	if state.phys.settings.currentClamp1
		setCurrentClamp(1);
	else
		setVoltageClamp(1);
	end



% --- Executes on button press in scopeButton.
function scopeButton_Callback(hObject, eventdata, handles)
% hObject    handle to scopeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function im0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to im0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function im0_Callback(hObject, eventdata, handles)
% hObject    handle to im0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of im0 as text
%        str2double(get(hObject,'String')) returns contents of im0 as a double


% --- Executes during object creation, after setting all properties.
function rm0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rm0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rm0_Callback(hObject, eventdata, handles)
% hObject    handle to rm0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rm0 as text
%        str2double(get(hObject,'String')) returns contents of rm0 as a double


% --- Executes during object creation, after setting all properties.
function rs0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rs0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rs0_Callback(hObject, eventdata, handles)
% hObject    handle to rs0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rs0 as text
%        str2double(get(hObject,'String')) returns contents of rs0 as a double


% --- Executes during object creation, after setting all properties.
function cm0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cm0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function cm0_Callback(hObject, eventdata, handles)
% hObject    handle to cm0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cm0 as text
%        str2double(get(hObject,'String')) returns contents of cm0 as a double


% --- Executes during object creation, after setting all properties.
function vm1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function vm1_Callback(hObject, eventdata, handles)
% hObject    handle to vm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vm1 as text
%        str2double(get(hObject,'String')) returns contents of vm1 as a double


% --- Executes during object creation, after setting all properties.
function im1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to im1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function im1_Callback(hObject, eventdata, handles)
% hObject    handle to im1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of im1 as text
%        str2double(get(hObject,'String')) returns contents of im1 as a double


% --- Executes during object creation, after setting all properties.
function rm1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rm1_Callback(hObject, eventdata, handles)
% hObject    handle to rm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rm1 as text
%        str2double(get(hObject,'String')) returns contents of rm1 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function cm1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function cm1_Callback(hObject, eventdata, handles)
% hObject    handle to cm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cm1 as text
%        str2double(get(hObject,'String')) returns contents of cm1 as a double


% --- Executes during object creation, after setting all properties.
function breakInTime0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to breakInTime0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function breakInTime0_Callback(hObject, eventdata, handles)
% hObject    handle to breakInTime0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of breakInTime0 as text
%        str2double(get(hObject,'String')) returns contents of breakInTime0 as a double


% --- Executes during object creation, after setting all properties.
function minInCell0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minInCell0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function minInCell0_Callback(hObject, eventdata, handles)
% hObject    handle to minInCell0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minInCell0 as text
%        str2double(get(hObject,'String')) returns contents of minInCell0 as a double


% --- Executes during object creation, after setting all properties.
function breakInTime1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to breakInTime1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function breakInTime1_Callback(hObject, eventdata, handles)
% hObject    handle to breakInTime1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of breakInTime1 as text
%        str2double(get(hObject,'String')) returns contents of breakInTime1 as a double


% --- Executes during object creation, after setting all properties.
function minInCell1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minInCell1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function minInCell1_Callback(hObject, eventdata, handles)
% hObject    handle to minInCell1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minInCell1 as text
%        str2double(get(hObject,'String')) returns contents of minInCell1 as a double


% --- Executes during object creation, after setting all properties.
function rs1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rs1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rs1_Callback(hObject, eventdata, handles)
% hObject    handle to rs1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rs1 as text
%        str2double(get(hObject,'String')) returns contents of rs1 as a double


% --- Executes on button press in liveModeButton.
function liveModeButton_Callback(hObject, eventdata, handles)
	phLiveModeButtonPressed;
