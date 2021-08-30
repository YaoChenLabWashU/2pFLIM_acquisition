function varargout = tilerControls(varargin)
% TILERCONTROLS Application M-file for tilerControls.fig
%    FIG = TILERCONTROLS launch tilerControls GUI.
%    TILERCONTROLS('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 21-Feb-2003 16:20:08

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
function varargout = updatePulseOutput_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	makeTilerOutput;



% --------------------------------------------------------------------
function varargout = updateWithDuration_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	makeTilerOutput;
	
% --------------------------------------------------------------------
function varargout = X_Callback(h, eventdata, handles, varargin)
	genericCallback(h);

% --------------------------------------------------------------------
function varargout = Y_Callback(h, eventdata, handles, varargin)
	genericCallback(h);


% --------------------------------------------------------------------
function varargout = selectButton_Callback(h, eventdata, handles, varargin)

	global state gh

	set(gh.tilerControls.selectButton, 'ForeGroundColor', [0 0 1]);
	setTilerStatusString('Click on spot');

	k = waitforbuttonpress;
	p1 = get(gca,'CurrentPoint');    % button down detected
	p1=p1(1,1:2);
	set(gh.tilerControls.selectButton, 'ForeGroundColor', [0 0 0]);
	setTilerStatusString('');

	state.internal.lineDelay = ((state.acq.lineDelay)/state.acq.msPerLine);
	startColumnForFrameData = round((state.internal.lineDelay*state.internal.samplesPerLine));	
	fractionStart=startColumnForFrameData/state.internal.samplesPerLine;
	fractionEnd=(state.acq.samplesAcquiredPerLine+startColumnForFrameData)/state.internal.samplesPerLine;
	fractionPerPixel=(fractionEnd-fractionStart)/state.acq.pixelsPerLine;

	mirrorPosition=state.acq.mirrorDataOutput(...
		round(round(p1(2)-1)*state.internal.lengthOfXData ...
		+state.internal.lengthOfXData*(fractionStart+p1(1)*fractionPerPixel)),:);
	state.tiler.X=mirrorPosition(1);
	state.tiler.Y=mirrorPosition(2);
	updateGUIByGlobal('state.tiler.X');	
	updateGUIByGlobal('state.tiler.Y');	



% --------------------------------------------------------------------
function varargout = seeInputButton_Callback(h, eventdata, handles, varargin)
	pulseModePlotInput;



% --------------------------------------------------------------------
function varargout = seeOutputButton_Callback(h, eventdata, handles, varargin)
	pulseModePlotOutput;



% --------------------------------------------------------------------
function varargout = doitButton_Callback(h, eventdata, handles, varargin)
	global gh state
	state.tiler.tiling=0;
	state.tiler.abort=1;

	if strcmp(get(gh.tilerControls.doitButton, 'String'), 'DO IT')
		turnOffAllChildren(gh.tilerControls.figure1);
		set(gh.tilerControls.doitButton, 'String', 'ABORT');
		set(gh.tilerControls.doitButton, 'enable', 'on');
		set(gh.tilerControls.statusString, 'enable', 'on');
		setTilerStatusString('Acquiring...');
		state.tiler.abort=0;
        tilerSetupForStart;
		drawnow;
        startTiler;
    else
% 		state.tiler.abort=1;
% 		setTilerStatusString('Aborting...');
% 		flushPulseModeData;
		set(gh.tilerControls.doitButton, 'String', 'DO IT');
		turnOnAllChildren(gh.tilerControls.figure1);
		setTilerStatusString('Reset');
	end



% --------------------------------------------------------------------
function varargout = tileSteps_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	makeTilerOutput;


% --------------------------------------------------------------------
function varargout = tileButton_Callback(h, eventdata, handles, varargin)
	global state
	state.tiler.abort=0;
	tilePulseMode;



% --------------------------------------------------------------------
function varargout = saveTileButton_Callback(h, eventdata, handles, varargin)
	saveTileResults;



% --------------------------------------------------------------------
function varargout = review_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state gh
	if state.tiler.tileCounter>state.tiler.tileSteps^2
		state.tiler.tileCounter=state.tiler.tileSteps^2;
		updateGUIByGlobal('state.tiler.tileCounter');
	end
	
	global pulseModeInputWave1 pulseModeInputWave2

	pulseModeInputWave1.data = state.tiler.tileAllResults1(state.tiler.tileCounter,:);
	pulseModeInputWave2.data = state.tiler.tileAllResults2(state.tiler.tileCounter,:);	


% --------------------------------------------------------------------
function varargout = plotTile_Callback(h, eventdata, handles, varargin)
	plotTileResults;
	


% --------------------------------------------------------------------
function varargout = counterSlider_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = loadTileBUtton_Callback(h, eventdata, handles, varargin)
	loadTileResults;



% --------------------------------------------------------------------
function varargout = selectTileXY_Callback(h, eventdata, handles, varargin)

	global state gh

	set(gh.tilerControls.selectTileXY, 'ForeGroundColor', [0 0 1]);
	setTilerStatusString('Click on tile');

	k = waitforbuttonpress;
	p1 = get(gca,'CurrentPoint');    % button down detected
	p1=p1(1,1:2);
	set(gh.tilerControls.selectTileXY, 'ForeGroundColor', [0 0 0]);
	setTilerStatusString('');

	state.tiler.X=p1(1);
	state.tiler.Y=-p1(2);
	updateGUIByGlobal('state.tiler.X');	
	updateGUIByGlobal('state.tiler.Y');	





% --------------------------------------------------------------------
function varargout = tileResult1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = tileResult2_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = fileCounter_Callback(h, eventdata, handles, varargin)
	genericCallback(h);


% --- Executes during object creation, after setting all properties.
function pulseSeparation_CreateFcn(hObject, eventdata, handles)
	if ispc
        set(hObject,'BackgroundColor','white');
	else
        set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
	end



function pulseSeparation_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	makeTilerOutput;
	


% --- Executes during object creation, after setting all properties.
function nTilesX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nTilesX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function nTilesY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nTilesY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function nTilesXSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nTilesXSlider (see GCBO)
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
function nTilesXSlider_Callback(hObject, eventdata, handles)
% hObject    handle to nTilesXSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


