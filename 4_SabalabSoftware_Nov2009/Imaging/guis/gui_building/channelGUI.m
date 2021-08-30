function varargout = channelGUI(varargin)
global state
% CHANNELGUI Application M-file for channelGUI.fig
%    FIG = CHANNELGUI launch channelGUI GUI.
%    CHANNELGUI('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 16-Nov-2005 11:33:01

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
function varargout = acquiringChannel1_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.savingChannel2.
% updates all the checkboxes accross a row when you acquire one channel.
	global state
	state.internal.channelChanged=1;
	genericCallback(h);
	if get(h, 'Value')
		state.acq.savingChannel1 = 1;
		updateGUIByGlobal('state.acq.savingChannel1');
		state.acq.imagingChannel1 = 1;
		updateGUIByGlobal('state.acq.imagingChannel1');
		state.acq.maxImage1 = 0;
		updateGUIByGlobal('state.acq.maxImage1');		
	else
		state.acq.savingChannel1 = 0;
		updateGUIByGlobal('state.acq.savingChannel1');
		state.acq.imagingChannel1 = 0;
		updateGUIByGlobal('state.acq.imagingChannel1');
		state.acq.maxImage1 = 0;
		updateGUIByGlobal('state.acq.maxImage1');
	end

% --------------------------------------------------------------------
function varargout = acquiringChannel2_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.imagingChannel1.
% updates all the checkboxes accross a row when you acquire one channel.
	global state
	state.internal.channelChanged=1;
	genericCallback(h)
	if get(h, 'Value')
		state.acq.savingChannel2 = 1;
		updateGUIByGlobal('state.acq.savingChannel2');
		state.acq.imagingChannel2 = 1;
		updateGUIByGlobal('state.acq.imagingChannel2');
		state.acq.focusingChannel2 = 1;
		updateGUIByGlobal('state.acq.maxImage2');
	else 
		state.acq.savingChannel2 = 0;
		updateGUIByGlobal('state.acq.savingChannel2');
		state.acq.imagingChannel2 = 0;
		updateGUIByGlobal('state.acq.imagingChannel2');
		state.acq.maxImage2 = 0;
		updateGUIByGlobal('state.acq.maxImage2');
	end



% --------------------------------------------------------------------
function varargout = acquiringChannel3_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.imagingChannel2.
% updates all the checkboxes accross a row when you acquire one channel.
	global state
	state.internal.channelChanged=1;
	genericCallback(h)
	if get(h, 'Value')
		state.acq.savingChannel3 = 1;
		updateGUIByGlobal('state.acq.savingChannel3');
		state.acq.imagingChannel3 = 1;
		updateGUIByGlobal('state.acq.imagingChannel3');
		state.acq.maxImage3 = 0;
		updateGUIByGlobal('state.acq.maxImage3');
	else
		state.acq.savingChannel3 = 0;
		updateGUIByGlobal('state.acq.savingChannel3');
		state.acq.imagingChannel3 = 0;
		updateGUIByGlobal('state.acq.imagingChannel3');
		state.acq.maxImage3 = 0;
		updateGUIByGlobal('state.acq.maxImage3');
	end

% --------------------------------------------------------------------
function varargout = acquiringChannel4_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.imagingChannel2.
% updates all the checkboxes accross a row when you acquire one channel.
	global state
	state.internal.channelChanged=1;
	genericCallback(h)
	if get(h, 'Value')
		state.acq.savingChannel4 = 1;
		updateGUIByGlobal('state.acq.savingChannel4');
		state.acq.imagingChannel4 = 1;
		updateGUIByGlobal('state.acq.imagingChannel4');
		state.acq.maxImage4 = 0;
		updateGUIByGlobal('state.acq.maxImage4');
	else
		state.acq.savingChannel4 = 0;
		updateGUIByGlobal('state.acq.savingChannel4');
		state.acq.imagingChannel4 = 0;
		updateGUIByGlobal('state.acq.imagingChannel4');
		state.acq.maxImage4 = 0;
		updateGUIByGlobal('state.acq.maxImage4');
	end
% --------------------------------------------------------------------
function varargout = generic_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.checkbox14.
	global state
	state.internal.channelChanged=1;
	genericCallback(h)


% --------------------------------------------------------------------
function varargout = composite_Callback(h, eventdata, handles, varargin)
	genericCallback(h)
	global state
	if state.internal.composite
		set(state.internal.compositeFigure, 'Visible', 'on')
	else
		set(state.internal.compositeFigure, 'Visible', 'off')
	end
		


