function varargout = physcyclegui(varargin)
% PHYSCYCLEGUI Application M-file for physcyclegui.fig
%    FIG = PHYSCYCLEGUI launch physcyclegui GUI.
%    PHYSCYCLEGUI('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 04-Mar-2003 10:10:59

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
%| callback type separated by '_', e.g. 'auxCounterSlider_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.auxCounterSlider. This
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
function varargout = rep_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	tag=get(h, 'Tag');
	pos=find(tag == '_');
	n=str2num(tag(pos+1:end));
	val=str2num(get(h, 'String'));
	updatePhysCycle(n+state.phys.cycle.startingPos-1, 1, val);
	savePhysCycleInMemory;
	global state gh
	if state.phys.cycle.autoSave
		savePhysCycle
	end
	eval(['setfocus(gh.physCycleGui.delay_' num2str(n) ');']);

% --------------------------------------------------------------------
function varargout = delay_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	tag=get(h, 'Tag');
	pos=find(tag == '_');
	n=str2num(tag(pos+1:end));
	val=str2num(get(h, 'String'));
	updatePhysCycle(n+state.phys.cycle.startingPos-1, 2, val);
	savePhysCycleInMemory;
	global state gh
	if state.phys.cycle.autoSave
		savePhysCycle
	end
	eval(['setfocus(gh.physCycleGui.da0_' num2str(n) ');']);

% --------------------------------------------------------------------
function varargout = da0_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	tag=get(h, 'Tag');
	pos=find(tag == '_');
	n=str2num(tag(pos+1:end));
	val=str2num(get(h, 'String'));
	updatePhysCycle(n+state.phys.cycle.startingPos-1, 3, val);
	savePhysCycleInMemory;
	global state gh
	if state.phys.cycle.autoSave
		savePhysCycle
	end
	eval(['setfocus(gh.physCycleGui.da1_' num2str(n) ');']);

% --------------------------------------------------------------------
function varargout = da1_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	tag=get(h, 'Tag');
	pos=find(tag == '_');
	n=str2num(tag(pos+1:end));
	val=str2num(get(h, 'String'));
	updatePhysCycle(n+state.phys.cycle.startingPos-1, 4, val);
	savePhysCycleInMemory;
	global state gh
	if state.phys.cycle.autoSave
		savePhysCycle
	end
	if n<4 
		eval(['setfocus(gh.physCycleGui.rep_' num2str(n+1) ');']);
	else
		state.phys.cycle.startingPosFlip=state.phys.cycle.startingPosFlip-1;
		updateGUIByGlobal('state.phys.cycle.startingPosFlip');
		startingPosFlipSlider_Callback(gh.physCycleGui.startingPosFlipSlider);
		eval(['setfocus(gh.physCycleGui.rep_' num2str(n) ');']);
	end


% --------------------------------------------------------------------
function varargout = del_Callback(h, eventdata, handles, varargin)
	tag=get(h, 'Tag');
	pos=find(tag == '_');
	row=str2num(tag(pos+1:end));
	deletePhysCycleRow(row);	
	savePhysCycleInMemory;
	global state
	if state.phys.cycle.autoSave
		savePhysCycle
	end

% --------------------------------------------------------------------
function varargout = ins_Callback(h, eventdata, handles, varargin)
	tag=get(h, 'Tag');
	pos=find(tag == '_');
	row=str2num(tag(pos+1:end));
	insertPhysCycleRow(row);	
	savePhysCycleInMemory;
	global state
	if state.phys.cycle.autoSave
		savePhysCycle
	end



% --------------------------------------------------------------------
function varargout = pos_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = startingPosFlipSlider_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	state.phys.cycle.startingPos=101-state.phys.cycle.startingPosFlip;
	redrawPhysCycle;


% --------------------------------------------------------------------
function varargout = displayCycleName_Callback(h, eventdata, handles, varargin)
	genericCallback(h);


% --------------------------------------------------------------------
function varargout = FileMenu_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = rsPulseNum_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	savePhysCycleInMemory;
	global state
	if state.phys.cycle.autoSave
 		savePhysCycle
	end




% --------------------------------------------------------------------
function varargout = autosave_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	if state.phys.cycle.autoSave
 		savePhysCycle
	end


function auxCounter_Callback(hObject, eventdata, handles)
% hObject    handle to auxCounter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auxCounter as text
%        str2double(get(hObject,'String')) returns contents of auxCounter as a double
	genericCallback(hObject);
	global state
	
	for counter=state.phys.cycle.startingPos:state.phys.cycle.startingPos + 3
		if counter - state.phys.cycle.startingPos + 1 <= size(state.phys.cycle.cycleDef,1)
			eval(['state.phys.cycle.aux_' num2str(counter - state.phys.cycle.startingPos + 1) ...
					'=state.phys.cycle.cycleDef(counter, 5 + state.phys.cycle.auxCounter);']);
			updateGUIByGlobal(['state.phys.cycle.aux_' num2str(counter - state.phys.cycle.startingPos + 1)]);		
		end
	end



function aux_Callback(h, eventdata, handles)
% hObject    handle to auxCounter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auxCounter as text
%        str2double(get(hObject,'String')) returns contents of auxCounter as a double
	genericCallback(h);
	global state
	tag=get(h, 'Tag');
	pos=find(tag == '_');
	n=str2num(tag(pos+1:end));
	val=str2num(get(h, 'String'));
	updatePhysCycle(n+state.phys.cycle.startingPos-1, 5+state.phys.cycle.auxCounter, val);
	savePhysCycleInMemory;
	global state gh
	if state.phys.cycle.autoSave
		savePhysCycle
	end

