function varargout = imageGUI(varargin)
% IMAGEGUI Application M-file for imageGUI.fig
%    FIG = IMAGEGUI launch imageGUI GUI.
%    IMAGEGUI('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 12-Feb-2001 16:09:31

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
function varargout = genericLUT_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.slider1.
%	set(h, 'Enable', 'off');
	try
		genericCallback(h);
        tag=get(h, 'Tag');
        chanNum=str2num(tag(end-1:end));
        if isempty(chanNum)
            chanNum=str2num(tag(end));
        end
        if isempty(chanNum)
            disp(['Unknown channel number from tag ' tag]);
            return
        end
		updateClim(chanNum);
	catch
		disp(['imageGUI: LUT callback. ' lasterr]);
	end
	set(h, 'Enable', 'on');

    
function varargout = reviewFrame(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.slider1.
	genericCallback(h);
	global state
	updateClim([], state.internal.reviewFrame);
	
% --------------------------------------------------------------------
function varargout = currentPosX_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.currentPosX.
disp('currentPosX Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = currentPosY_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.currentPosY.
disp('currentPosY Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = intensity_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.intensity.
disp('intensity Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = compositeChannel_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	siUpdateCompositeChannels;
	siRedrawImages;
	
% --------------------------------------------------------------------
function varargout = compositeCheckbox(h, eventdata, handles, varargin)
	genericCallback(h)
	global state
	if state.internal.composite
		set(state.internal.compositeFigure, 'Visible', 'on')
	else
		set(state.internal.compositeFigure, 'Visible', 'off')
	end	
