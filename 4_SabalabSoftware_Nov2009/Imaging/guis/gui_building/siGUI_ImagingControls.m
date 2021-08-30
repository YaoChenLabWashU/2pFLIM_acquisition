function varargout = siGUI_ImagingControls(varargin)
% siGUI_ImagingControls Application M-file for siGUI_ImagingControls.fig
%    FIG = siGUI_ImagingControls launch simpleModeGUI GUI.
%    siGUI_ImagingControls('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 15-Jan-2001 15:14:20

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

% --------------------------------------------------------------------
function varargout = generic_Callback(h, eventdata, handles, varargin)
% Stub for Callback of most uicontrol handles
	genericCallback(h);
	global state
	state.internal.secondsCounter=state.cycle.nextTimeDelay;
	updateGUIByGlobal('state.internal.secondsCounter');

function varargout = ZSlice_Callback(h, eventdata, handles, varargin)
% Stub for Callback of most uicontrol handles
	genericCallback(h);
	preallocateMemory;
	
function varargout = numberOfFrames_Callback(h, eventdata, handles, varargin)
% Stub for Callback of most uicontrol handles
	genericCallback(h);
	global state

	preallocateMemory;
	
	if state.acq.dualLaserMode==1 % if the lasers are on simulataneously then nothing special
		sampleFactor=1;
	elseif state.acq.dualLaserMode==2
		sampleFactor=2;	% if they are alternating, then double the number of acqs before trigger the trigger function
	else
		disp('	setupInputChannels needs more for lasermodes');
	end
	global grabInput
	set(grabInput, 'SamplesPerTrigger', sampleFactor*state.internal.samplesPerFrame*state.acq.numberOfFrames);

	state.internal.needNewPcellRepeatedOutput=1;
	state.internal.needNewRepeatedMirrorOutput=1;
	applyChangesToOutput;
	updateClim
	
function varargout = averaging_Callback(h, eventdata, handles, varargin)
% Stub for Callback of most uicontrol handles
	genericCallback(h);
	preallocateMemory;
	
% --------------------------------------------------------------------
function varargout = focusButton_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.focusButton.
 	global gh
	figure(gh.siGUI_ImagingControls.figure1);
	executeFocusCallback;	
		
% --------------------------------------------------------------------
function varargout = grabOneButton_Callback(h, eventdata, handles, varargin)
 	global gh
	figure(gh.siGUI_ImagingControls.figure1);
	executeGrabOneCallback;

function varargout = dualLaserMode_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	updateDataForConfiguration;
