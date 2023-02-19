function varargout = pcellcontrol(varargin)
% PCELLCONTROL Application M-file for pcellControl.fig
%    FIG = PCELLCONTROL launch pcellControl GUI.
%    PCELLCONTROL('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 10-Apr-2002 17:24:44

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
function varargout = default_Callback(h, eventdata, handles, varargin)
%	set(h, 'Enable', 'off');	
	genericCallback(h);
	set(h, 'Enable', 'on');	

function varargout = flybackChange(h, eventdata, handles, varargin)
%	set(h, 'Enable', 'off');	
	genericCallback(h);
	handleChange
	set(h, 'Enable', 'on');	

function varargout = restingChange(h, eventdata, handles, varargin)
%	set(h, 'Enable', 'off');	
	genericCallback(h);
	handleChange
	set(h, 'Enable', 'on');	

function varargout = dualChange(h, eventdata, handles, varargin)
%	set(h, 'Enable', 'off');	
	genericCallback(h);
	handleChange
	set(h, 'Enable', 'on');	

% --------------------------------------------------------------------
function varargout = genericUpdate_Callback(h, eventdata, handles, varargin)
%	set(h, 'Enable', 'off');	
	genericCallback(h);
    try
        global state
        disp(['Laser 2 power = ' ...
               num2str(state.pcell.pcellPowerCal2(1+round(state.pcell.pcellScanning2)))...
                ' mW']);
        state.pcell.pcellScanningPower2=state.pcell.pcellPowerCal2(1+round(state.pcell.pcellScanning2));
    catch
        state.pcell.pcellScanningPower2=-1;
    end
    updateHeaderString('state.pcell.pcellScanningPower2');
    try
        global state
        disp(['Laser 1 power = ' ...
               num2str(state.pcell.pcellPowerCal1(1+round(state.pcell.pcellScanning1)))...
                ' mW']);
        state.pcell.pcellScanningPower1=state.pcell.pcellPowerCal1(1+round(state.pcell.pcellScanning1));
    catch
        state.pcell.pcellScanningPower1=-1;
    end
    updateHeaderString('state.pcell.pcellScanningPower1');    
	handleChange;
	set(h, 'Enable', 'on');	

% --------------------------------------------------------------------
function varargout = boxNumber_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	setLength=settingsManager('getsetlength', 'pcellBox');
	if state.pcell.boxNumber>setLength
		state.pcell.boxStartX=0;
		state.pcell.boxStartY=0;
		state.pcell.boxEndX=0;
		state.pcell.boxEndY=0;
		state.pcell.boxPowerLevel1=0;
		state.pcell.boxPowerLevel2=0;
		state.pcell.boxActiveStatus=0;
		state.pcell.boxFrameNumber=1;
		state.pcell.boxSliceNumber=1;
		settingsManager('store', 'pcellBox', state.pcell.boxNumber);
		settingsManager('refresh', 'pcellBox', state.pcell.boxNumber);
	else		
		settingsManager('recall', 'pcellBox', state.pcell.boxNumber);
	end

% --------------------------------------------------------------------
function varargout = boxChange_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	guiGlobal=getUserDataField(h, 'Global');
	settingsManager('storeone', 'pcellBox', state.pcell.boxNumber, guiGlobal);
	handleChange;
	set(h, 'Enable', 'on');	


% --------------------------------------------------------------------
function varargout = selectBoxButton_Callback(h, eventdata, handles, varargin)
	global state 

	setStatusString('Drag over ROI');

	siSelectionChannelToFront
	[y, x]=getBoxCoords([], 1)	% get a box with the coords sorted by X
	setStatusString('');

	if isempty(x) || isempty(y)
		return
	end
	
	state.pcell.boxStartX=x(1);
	state.pcell.boxStartY=y(1);
	state.pcell.boxEndX=x(2);
	state.pcell.boxEndY=y(2);

	settingsManager('store', 'pcellBox', state.pcell.boxNumber);
	handleChange;

function varargout = showHideBoxControls(h, eventdata, handles, varargin)
	siShowHidePcellBoxControls
	

function varargout = selectXYZButton_Callback(h, eventdata, handles, varargin)
	global state 

	setStatusString('Drag over ROI');

	siSelectionChannelToFront

	[y, x]=getBoxCoords([], 1);	% get a box with the coords sorted by X
	setStatusString('');

	if isempty(x) || isempty(y)
		return
	end
		
	[maxImage, maxIndex]=extractMaxFromStack(state.internal.selectionChannel, x, y);
	state.pcell.boxSliceNumber=mode(maxIndex);
	updateGUIByGlobal('state.pcell.boxSliceNumber');
	
	state.pcell.boxStartX=x(1);
	state.pcell.boxStartY=y(1);
	state.pcell.boxEndX=x(2);
	state.pcell.boxEndY=y(2);

	settingsManager('store', 'pcellBox', state.pcell.boxNumber);
	handleChange;

function handleChange
	global state
	state.internal.needNewPcellPowerOutput=1;
	try
		applyChangesToOutput;
	catch
		disp(['error in apply pcell change : ' lasterr]);
	end
