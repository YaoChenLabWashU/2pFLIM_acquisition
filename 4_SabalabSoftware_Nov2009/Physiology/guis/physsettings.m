function varargout = physsettings(varargin)
% PHYSSETTINGS Application M-file for physSettings.fig
%    FIG = PHYSSETTINGS launch physSettings GUI.
%    PHYSSETTINGS('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 29-Oct-2009 12:07:33

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
function varargout = generic_Callback(h, eventdata, handles, varargin)
	genericCallback(h);

% --------------------------------------------------------------------
function varargout = changeAcqChannel_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	setupPhysDaqInputChannels;

% --------------------------------------------------------------------
function varargout = changeChannel0_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	changeChannelType(0);
	
% --------------------------------------------------------------------
function varargout = changeChannel1_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	changeChannelType(1);

% --------------------------------------------------------------------
function varargout = outputRate_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	phSetDAQRates

% --------------------------------------------------------------------
function varargout = inputRate_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	phSetDAQRates


% --------------------------------------------------------------------
function varargout = autoSavePatterns_Callback(h, eventdata, handles, varargin)
	genericCallback(h);


% --- Executes on button press in streamToDisk.
function streamToDisk_Callback(hObject, eventdata, handles)
% hObject    handle to streamToDisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of streamToDisk
