function varargout = scope(varargin)
global scopeInput
% SCOPE Application M-file for scope.fig
%    FIG = SCOPE launch scope GUI.
%    SCOPE('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 24-Sep-2009 11:13:59

if nargin == 0  % LAUNCH GUI
	
	fig = openfig(mfilename,'reuse');
	
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
function varargout = generic_Callback(h, eventdata, handles, varargin)
	set(h, 'Enable', 'inactive');
	try
		genericCallback(h);
		global state
		state.phys.scope.RsAvg=0;
		state.phys.scope.CmAvg=0;
		state.phys.scope.RInAvg=0;
		state.phys.scope.counter=0;
	catch
	end
	set(h, 'Enable', 'on');
	

% --------------------------------------------------------------------
function varargout = generic_needNewScope(h, eventdata, handles, varargin)
	set(h, 'Enable', 'inactive');
	try
		genericCallback(h);
		global state
		state.phys.internal.needNewScopeOutput=1;
		state.phys.scope.RsAvg=0;
		state.phys.scope.CmAvg=0;
		state.phys.scope.RInAvg=0;
		state.phys.scope.counter=0;
	catch
	end
	set(h, 'Enable', 'on');

% --------------------------------------------------------------------
function varargout = changedChannel_Callback(h, eventdata, handles, varargin)
	set(h, 'Enable', 'inactive');
	try
	%	stopScope;

		global state gh
		run=0;
     	if ~strcmp(get(gh.scope.start, 'String'), 'Start')
			state.phys.scope.needToStop=1;
     		run=1;
		end
		pause(0.1);
		genericCallback(h);
		state.phys.internal.needNewScopeOutput=1;
		state.phys.internal.scopeChannelChanged=1;
%      	if run
% 			while ~strcmp(get(gh.scope.start, 'String'), 'Start')
% 				pause(0.01);
% 			end	
% 			pause(0.05);
% 			start_Callback;
% 		end
	catch
	end
	set(h, 'Enable', 'on');

% --------------------------------------------------------------------
function varargout = expand_Callback(h, eventdata, handles, varargin)
	global state gh
	if ~state.phys.scope.autoScale
		currentYlims=get(state.phys.internal.scopeAxisHandle,'YLim');
		range=currentYlims(2)-currentYlims(1);
		set(state.phys.internal.scopeAxisHandle,'YLim',[currentYlims(1)-.1*(range) currentYlims(2)+.1*(range)]);
%		state.phys.scope.lowRange = currentYlims(1)-.1*(range);
%		state.phys.scope.highRange = currentYlims(2)+.1*(range);
%		updateGUIByGlobal('state.phys.scope.highRange');
%		updateGUIByGlobal('state.phys.scope.lowRange');
	else
		autotog_Callback(gh.scope.autotog);
	end

% --------------------------------------------------------------------
function varargout = autotog_Callback(h, eventdata, handles, varargin)
	global state
	%control axis limits....
	if state.phys.scope.autoScale	%rescale axis and save old limits...
		set(h, 'String', 'Auto');
		state.phys.scope.autoScale=0;
%		YLims=get(state.phys.internal.scopeAxisHandle,'YLim');
%		state.phys.scope.lowRange = YLims(1);
%		state.phys.scope.highRange = YLims(2);
%		updateGUIByGlobal('state.phys.scope.highRange');
%		updateGUIByGlobal('state.phys.scope.lowRange');
		freeze(state.phys.internal.scopeAxisHandle);
	else
		set(h, 'String', 'Freeze');
		state.phys.scope.autoScale=1;
		release(state.phys.internal.scopeAxisHandle);
	end
	
	

% --------------------------------------------------------------------
function varargout = start_Callback(h, eventdata, handles, varargin)
	global state gh


	persistent multipleAbortAttempts
	
	if (exist('multipleAbortAttempts', 'var')~=1)
		multipleAbortAttempts=0;
	end
	
	if strcmp(get(gh.scope.start, 'String'), 'Start')
		if ~ishandle(state.phys.internal.scopeHandle)
			error('Scope window has been destroyed');
		end
		multipleAbortAttempts=0;
		timerRequestPause('Physiology');
		
		set(state.phys.internal.scopeHandle, 'Visible', 'on');	
		setPhysStatusString('Running Scope...');
		set(gh.physControls.startButton, 'Enable', 'off');
		set(gh.physControls.liveModeButton, 'Enable', 'off');
		
		set(gh.scope.start, 'String', 'Stop');
		state.phys.scope.needToStop=0;
		state.phys.daq.scopeTriggerTime=[0 0 0 0 0 0];
		state.phys.scope.firstTime=1;
		state.phys.scope.RsAvg=0;
		state.phys.scope.CmAvg=0;
		state.phys.scope.RInAvg=0;
		state.phys.scope.counter=0;
% 		readTelegraphs;
% 		makeScopeOutput;
% 		resetScopeDaq;
		state.phys.internal.needNewScopeOutput=1;
		state.phys.internal.scopeChannelChanged=1;

		startScopeLoop;
	else
		state.phys.scope.needToStop=1;
		setPhysStatusString('Stopping Scope...');
		if strcmp(state.phys.daq.scopeInputDevice.Running, 'Off')
			stopScope;
		end		
		multipleAbortAttempts=multipleAbortAttempts+1;
		if multipleAbortAttempts>1;
			stopScope;
		end
	end

% --------------------------------------------------------------------
function varargout = range_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	set(state.phys.internal.scopeAxisHandle, 'YLim', [state.phys.scope.lowRange state.phys.scope.highRange]);


% --------------------------------------------------------------------
function varargout = noteR_Callback(h, eventdata, handles, varargin)
	global state

	chStr= num2str(state.phys.scope.channel);
	if eval(['state.phys.settings.currentClamp' chStr])
		str='Current clamp';
	else
		str='Voltage clamp';
	end

	addEntryToNotebook(1, [datestr(clock,13) '   ' str ' parameters for Channel ' chStr], 0);
	addEntryToNotebook(1, ['     RIn = ' num2str(state.phys.scope.RIn) ' MOhm;  Rs = ' ...
			num2str(state.phys.scope.Rs) ' MOhm;  Cm = ' num2str(state.phys.scope.Cm) ' pF'], 0);
	addEntryToNotebook(1, ['     <RIn> = ' num2str(state.phys.scope.RInAvg) ' MOhm;  <Rs> = ' ...
			num2str(state.phys.scope.RsAvg) ' MOhm;  <Cm> = ' num2str(state.phys.scope.CmAvg) ' pF'], 1);
	addEntryToNotebook(1, ['     Vm = ' num2str(getfield(state.phys.cellParams, ['vm' chStr])) ...
			' mV;   Im = ' num2str(getfield(state.phys.cellParams, ['im' chStr])) ' pA']);
	
% --------------------------------------------------------------------
function varargout = inCell_Callback(h, eventdata, handles, varargin)
	global state
	
	hitclock=clock;
	eval(['state.phys.cellParams.breakInClock' num2str(state.phys.scope.channel) '=hitclock;']);
	timeString=datestr(hitclock, 13);
	eval(['state.phys.cellParams.breakInTime' num2str(state.phys.scope.channel) '=timeString;']);
	updateGUIByGlobal(['state.phys.cellParams.breakInTime' num2str(state.phys.scope.channel)]);
	updateMinInCell;
	addEntryToNotebook(1, [datestr(hitclock,0) ': Broke into cell on channel #' num2str(state.phys.scope.channel)]);
	addEntryToNotebook(2, [datestr(hitclock,0) ': Broke into cell on channel #' num2str(state.phys.scope.channel)]);

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
