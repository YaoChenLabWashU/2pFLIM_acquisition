function varargout = spc_main(varargin)
% SPC_MAIN Application M-file for spc_main.fig
%    FIG = SPC_MAIN launch spc_main GUI.
%    SPC_MAIN('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 15-Dec-2012 12:40:20
global gui;
global spc;

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');
    
	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    gui.spc.spc_main = handles;
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
    end

    % set up the correspondences between GUI & Globals
    % using multiple (Cell Array) globals for spc.fits and spc.switchess
    setGlobalGUIPairs(handles);  
    set(handles.slider1,'Max',0,'Min',-20,'Value',0,'SliderStep',[.05 .05]);

    
    
    % commented out gy 20110120 - can't be executed except at window
    % opening
%     try
%         spc.fit.beta0 = [1.8437e+003 10.1263 2.1007e+003 2.7551 5.7457 0.4692];
%         spc.datainfo.psPerUnit=195.4292;
%         range = round(spc.fit.range.*spc.datainfo.psPerUnit/100)/10;
%         set(handles.spc_fitstart, 'String', num2str(range(1)));
%         set(handles.spc_fitend, 'String', num2str(range(2)));
%         set(handles.back_value, 'String', num2str(spc.fit.background));
%         set(handles.filename, 'String', spc.filename);
%         set(handles.spc_page, 'String', num2str(spc.switches.currentPage));
%         %GY set(handles.slider1, 'Value', (spc.switches.currentPage-1)/100);
%         spc_dispbeta;
%     catch
%     end;
%    set (handles.selectAll, 'Value', 1);    

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

% 	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
% 	catch
% 		disp(lasterr);
% 	end

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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Menu bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%File menu
% --------------------------------------------------------------------
function varargout = spc_file_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = spc_open_Callback(h, eventdata, handles, varargin)
global spc;
global spcs;
global gui;
%spc.fit.range(1) = 	str2num(get(handles.spc_fitstart, 'String'))/spc.datainfo.psPerUnit*1000;
%spc.fit.range(2) =	str2num(get(handles.spc_fitend, 'String'))/spc.datainfo.psPerUnit*1000;
page = str2num(get(handles.spc_page, 'String'));

spc.lifetime = zeros(1,64);

[fname,pname] = uigetfile('*.sdt;*.mat;*.tif','Select spc-file');
cd (pname);
filestr = [pname, fname];
if exist(filestr) == 2
        spc_openCurves(filestr, page);
end
%spc_putIntoSPCS;
%spc_updateMainStrings;

% --------------------------------------------------------------------
function varargout = spc_loadPrf_Callback(h, eventdata, handles, varargin)
global spc;
[fname,pname] = uigetfile('*.mat','Select mat-file');
if exist([pname, fname]) == 2
    load ([pname,fname], 'prf');
end
spc.fits{spc_mainChannelChoice}.prf = prf;

% --------------------------------------------------------------------
function varargout = spc_savePrf_Callback(h, eventdata, handles, varargin)
% now saves current channel Lifetime data as PRF gy 20120619
global spc;
[fname,pname] = uiputfile('*.mat','Select the mat-file');
if fname==0
    return
end
% USED TO BE prf = spc.fits{spc_mainChannelChoice}.prf;
prf = spc.lifetimes{spc_mainChannelChoice};
% get a zero baseline from the last third of the data
baseline=mean(prf(floor(.65*numel(prf)):floor(.9*numel(prf))));
disp(['Baseline of ' num2str(baseline) ' subtracted...']);
prf=prf-baseline;
% zero out the last 10%
prf(floor(.9*numel(prf)):numel(prf))=0;
% make sure there are no negative numbers
prf(prf<0)=0;
% normalize to unit area
prf=prf/sum(prf);
% use this prf for current fits
spc.fits{spc_mainChannelChoice}.prf=prf;
% and save in a file
    save ([pname,fname], 'prf');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fitting menu
% --------------------------------------------------------------------
function varargout = spc_fitting_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = spc_exps_Callback(h, eventdata, handles, varargin)
global spc
disp('spc_main:spc_exps not up to date');
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% range = spc.fit.range;
% lifetime = spc.lifetime(range(1):1:range(2));
% x = [1:1:length(lifetime)];
% beta0 = [max(lifetime), sum(lifetime)/max(lifetime)];
% betahat = spc_nlinfit(x, lifetime, sqrt(lifetime)/sqrt(max(lifetime)), @expfit, beta0);
% tau = betahat(2)*spc.datainfo.psPerUnit/1000;
% set(handles.beta1, 'String', num2str(betahat(1)));
% set(handles.beta2, 'String', num2str(tau));
% set(handles.beta3, 'String', '0');
% set(handles.beta4, 'String', '0');
% set(handles.beta5, 'String', '0');
% set(handles.pop1, 'String', '100');
% set(handles.pop2, 'String', '0');
% set(handles.avgTau, 'String', num2str(tau));
% 
% %Drawing
% fit = expfit(betahat, x);
% t = [range(1):1:range(2)];
% t = t*spc.datainfo.psPerUnit/1000;
% spc_drawfit (t, fit, lifetime, betahat);


% function y=expfit(beta0, x);
% global spc;
% if spc.switches.imagemode == 1
%     spc_roi = get(spc.figure.roi, 'Position');
% else
%     spc_roi = [1,1,1,1]
% end;
% y=exp(-x/beta0(2))*beta0(1);

% --------------------------------------------------------------------
function varargout = fit_single_gauss_Callback(h, eventdata, handles, varargin)
% gy multiFLIM updated 201111
chan=spc_mainChannelChoice;
spc_fitexpgaussGY(chan);
fitMenuChecks(handles,chan);

% --------------------------------------------------------------------
function varargout = fit_double_gauss_Callback(h, eventdata, handles, varargin)
% gy multiFLIM updated 201111
chan=spc_mainChannelChoice;
spc_fitexp2gaussGY(chan); %automatically translates back and forth, and updates GUI if match
fitMenuChecks(handles,chan);

% --------------------------------------------------------------------
function varargout = expgauss_triple_Callback(h, eventdata, handles, varargin)
disp('spc_main:expgauss_triple not implemented now');
%spc_fitWithSingleExp_triple;

% --------------------------------------------------------------------
function varargout = Double_expgauss_triple_Callback(h, eventdata, handles, varargin)
disp('spc_main:Double_expgauss_triple not implemented now');
%spc_fitWithDoubleExp_triple;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Drawing menu
% --------------------------------------------------------------------
function varargout = spc_drawing_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = spc_drawall_Callback(h, eventdata, handles, varargin)
disp('spc_main:drawall:  no function at present');
% GY spc_spcsUpdate;
%spc_redrawSetting(1);

% --------------------------------------------------------------------
function varargout = logscale_Callback(h, eventdata, handles, varargin)
spc_logscale;

function varargout = show_all_Callback(h, eventdata, handles, varargin)
spc_drawLifetimeMap_All(0);
% --------------------------------------------------------------------
function varargout = redraw_all_Callback(h, eventdata, handles, varargin)
spc_drawLifetimeMap_All(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Analysis menu
% --------------------------------------------------------------------
function varargout = analysis_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = smoothing_Callback(h, eventdata, handles, varargin)
disp('spc_main:smoothing not implemented now');
%spc_smooth;
% --------------------------------------------------------------------
function varargout = binning_Callback(h, eventdata, handles, varargin)
disp('spc_main:binning not implemented now');
%spc_binning;

% --------------------------------------------------------------------
function varargout = smooth_all_Callback(h, eventdata, handles, varargin)
disp('spc_main:smooth_all not implemented now');
%spc_smoothAll;

% --------------------------------------------------------------------
function varargout = binning_all_Callback(h, eventdata, handles, varargin)
disp('spc_main:binning_all not implemented now');
%spc_binningAll;

% --------------------------------------------------------------------
function varargout = undoall_Callback(h, eventdata, handles, varargin)
disp('spc_main:undoall not implemented now');
%spc_undoAll;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function varargout = spc_fit1_Callback(h, eventdata, handles, varargin)
global spc
chan=spc_mainChannelChoice;
if isfield(spc.fits{chan},'lastFitFunction')
    % use the last fit function, but make sure it's single exp
    fh=str2func(spc_fitFuncName(spc.fits{chan}.lastFitFunction,1));
    fh(chan);
else spc_fitexpgaussGY(chan);
end
fitMenuChecks(handles,chan);


% --------------------------------------------------------------------
function varargout = spc_fit2_Callback(h, eventdata, handles, varargin)
global spc
chan=spc_mainChannelChoice;
if isfield(spc.fits{chan},'lastFitFunction')
    % use the last fit function, but make sure it's double exp
    fh=str2func(spc_fitFuncName(spc.fits{chan}.lastFitFunction,2));
    fh(chan);
else spc_fitexp2gaussGY(chan);
end
fitMenuChecks(handles,chan);

% --------------------------------------------------------------------
function varargout = spc_look_Callback(h, eventdata, handles, varargin)
% called upon press of the 'plot current' button
% uses exp2gauss
global spc;
chan=spc_mainChannelChoice;
[beta0 range]=spc_fitParamsFromGlobal(chan);
lifetime = spc.lifetimes{chan}(range(1):1:range(2));
x = [1:1:length(lifetime)];

% pop1 = beta0(1)/(beta0(1)+beta0(3));
% pop2 = beta0(3)/(beta0(1)+beta0(3));
% set(handles.pop1, 'String', num2str(pop1));
% set(handles.pop2, 'String', num2str(pop2));

%Drawing
fit = exp2gauss(beta0, x);
t = [range(1):1:range(2)]*spc.datainfo.psPerUnit/1000;

%Drawing
spc_drawfit (t, fit, lifetime, beta0, chan);
% spc_dispbeta;

% --------------------------------------------------------------------
function varargout = spc_redraw_Callback(h, eventdata, handles, varargin)
global spc;
chan=spc_mainChannelChoice;
[~, range]=spc_fitParamsFromGlobal(chan);
if range(1) < 1
    range(1)= 1;
end
if range(2) <0
    range(2) = spc.size(1);
end
if range(2) < range(1)
    range(2) = spc.size(1);
    range(1) = 1;
end
spc_rangeIntoGlobal(range,chan,1);
spc_redrawSetting(1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Beta windows
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function varargout = beta1_Callback(h, eventdata, handles, varargin)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM
% --------------------------------------------------------------------
function varargout = beta2_Callback(h, eventdata, handles, varargin)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM
% --------------------------------------------------------------------
function varargout = beta3_Callback(h, eventdata, handles, varargin)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM
% --------------------------------------------------------------------
function varargout = beta4_Callback(h, eventdata, handles, varargin)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM
% --------------------------------------------------------------------
function varargout = beta5_Callback(h, eventdata, handles, varargin)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM
% --------------------------------------------------------------------
function varargout = beta6_Callback(h, eventdata, handles)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM
% --------------------------------------------------------------------
function varargout = spc_fitstart_Callback(h, eventdata, handles, varargin)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM
% --------------------------------------------------------------------
function varargout = spc_fitend_Callback(h, eventdata, handles, varargin)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM
% --------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Spc, page control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = spc_page_Callback(h, eventdata, handles, varargin)
global spc;
disp('spc_main:spc_page not implemented');
return
%%%%%%%%%%%%%%%%%%%%%%%%%%
% page = str2num(get(handles.spc_page, 'String'));
% current = spc.page;
% spc.page = page;
% if current ~= spc.page
%     spc_opencurves(spc.filename, spc.page);
%     spc_redrawSetting;
% end
% spc_updateMainStrings;



% --------------------------------------------------------------------
function varargout = spcN_Callback(h, eventdata, handles, varargin)
global spcs;
global spc;
disp('spc_main:spcN is not supported now - gy 201111');
% spcN = str2num(get(handles.spcN, 'String'));
% 
% spc_changeCurrent(spcN);
% 
%  %set(handles.spcN, 'String', num2str(spcs.current));
%  %set(handles.slider2, 'Value', (spcs.current-1)/100);
%  %set(handles.filename, 'String', num2str(spc.filename));
% spc_updateMainStrings;

% --------------------------------------------------------------------
function varargout = slider2_Callback(h, eventdata, handles, varargin)
disp('spc_main:slider2 is not supported now - gy 201111');
% slider_value = get(handles.slider2, 'Value');
% slider_step = get(handles.slider2, 'sliderstep');
% spcN = slider_value*100+1;
% 
% %spc_changeCurrent(spcN);
%     
% %set(handles.spcN, 'String', num2str(spcs.current));
% %set(handles.slider2, 'Value', (spcs.current-1)/100);
% %set(handles.filename, 'String', num2str(spc.filename));
% spc_updateMainStrings;


% --------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Utilities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = fixtau1_Callback(h, eventdata, handles, varargin)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM

function varargout = fixtau2_Callback(h, eventdata, handles, varargin)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM

function fix_g_Callback(h, eventdata, handles)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM

function fix_delta_Callback(h, eventdata, handles)
spc_GUIchange(h,[],handles);  % added GUI management with multiFLIM

% --- Executes on button press in timecourse.
function timecourse_Callback(hObject, eventdata, handles)
% hObject    handle to timecourse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%timecourse Pushbutton.
disp('spc_main:timecourse may not be updated');
spc_auto(1);

% --- Executes during object creation, after setting all properties.
function beta6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in spc_opennext. Open the next file.
function spc_opennext_Callback(hObject, eventdata, handles)
% hObject    handle to spc_opennext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spc FLIMchannels state
spc_openFiles(0,1);
if get(handles.fit_eachtime,'Value')==1
    for fc=FLIMchannels
        if ~bitget(state.spc.FLIMchoices(fc),3) % avoid calc'ed channels
            if isfield(spc.fits{fc},'lastFitFunction')
                % use the last fit function automatically
                fh=str2func(spc.fits{fc}.lastFitFunction);
                fh(fc);
            else spc_fitexp2gaussGY(fc);
            end
            if fc==spc_mainChannelChoice
                fitMenuChecks(handles,fc);
            end
        end
    end
end

% --- Executes on button press in spc_openprevious. Open the Previous file.
function spc_openprevious_Callback(hObject, eventdata, handles)
% hObject    handle to spc_openprevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spc FLIMchannels state
spc_openFiles(0,-1);
if get(handles.fit_eachtime,'Value')==1
    for fc=FLIMchannels
        if ~bitget(state.spc.FLIMchoices(fc),3) % avoid calc'ed channels
            if isfield(spc.fits{fc},'lastFitFunction')
                % use the last fit function automatically
                fh=str2func(spc.fits{fc}.lastFitFunction);
                fh(fc);
            else spc_fitexp2gaussGY(fc);
            end
            if fc==spc_mainChannelChoice
                fitMenuChecks(handles,fc);
            end
        end
    end
end



function Roi_Select_Callback(hObject,eventdata,handles)
global spc gui FLIMchannels
tag=get(hObject,'Tag');
roiNum=str2double(tag(end));
% check for existence of the chosen ROI
if isfield(gui.gy,'rois')
    nROI=numel(gui.gy.rois);
    if roiNum>nROI
        disp(['Highest ROI available is ' num2str(nROI)]); return
    end
else
    disp('No ROIs to select'); return;
end
mask=gui.gy.rois{roiNum}.mask;
nsPerPoint=spc.datainfo.psPerUnit/1000;
for chan=FLIMchannels
    spc_calcLifetimeInROI(chan,mask);
    % now re-display the lifetime
    [~,range]=spc_fitParamsFromGlobal(chan);
    t = (range(1):range(2))*nsPerPoint;
    lifetime = spc.lifetimes{chan}(range(1):1:range(2));
    lifetime = lifetime(:);
    set(gui.spc.figure.lifetimePlot(chan), 'XData', t, 'YData', lifetime);
end
set(gui.spc.figure.lifetimeAxes, 'XTick', []);
if (spc.switches.logscale == 0)
    set(gui.spc.figure.lifetimeAxes, 'YScale', 'linear');
else
    set(gui.spc.figure.lifetimeAxes, 'YScale', 'log');
end


function File_N_Callback(hObject, eventdata, handles)
% hObject    handle to File_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of File_N as text
%        str2double(get(hObject,'String')) returns contents of File_N as a double

global spc;
spc_openFiles(str2double(get(handles.File_N, 'String')));

% --- Executes during object creation, after setting all properties.
function File_N_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in auto_A.
function auto_A_Callback(hObject, eventdata, handles)
spc_adjustTauOffset(spc_mainChannelChoice);

function F_offset_Callback(hObject, eventdata, handles)
global spc
spc_GUIchange(hObject,[],handles);  % added GUI management with multiFLIM
chan=spc_mainChannelChoice;
spc_drawLifetimeMap(chan,1); % redraw this channels lt map
% if there is a dependent channel (sum), then recalc/redraw it now
if ~isempty(spc.fits{chan}.dependentChan)
    spc_drawLifetimeMap(spc.fits{chan}.dependentChan,1);
end
spc_calculateROIvals(0);
%spc_redrawSetting (1);

% --- Executes during object creation, after setting all properties.
function F_offset_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function fit_single_prf_Callback(hObject, eventdata, handles)
% hObject    handle to fit_double_prf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spc
chan=spc_mainChannelChoice;
if ~isfield(spc.fits{chan}, 'prf');
    spc_prfdefault(chan); 
end
if length(spc.fits{chan}.prf) ~= length(spc.lifetimes{chan})
    spc_prfdefault(chan);
end

spc_fitexpprfGY(chan); 
fitMenuChecks(handles,chan);

% --------------------------------------------------------------------
function fit_double_prf_Callback(hObject, eventdata, handles)
global spc
chan=spc_mainChannelChoice;
if ~isfield(spc.fits{chan}, 'prf');
    spc_prfdefault(chan); 
end
if length(spc.fits{chan}.prf) ~= length(spc.lifetimes{chan})
    spc_prfdefault(chan);
end
spc_fitexp2prfGY(chan); 
fitMenuChecks(handles,chan);


% --- Executes on button press in fit_eachtime.
function fit_eachtime_Callback(hObject, eventdata, handles)


% --- Executes on button press in selectAll.
function selectAll_Callback(hObject, eventdata, handles)


% --- Executes on button press in SPCreview.
function SPCreview_Callback(hObject, eventdata, handles)
gy_SPCreview;


function fitMenuChecks(handles,chan)
global spc
items=get(handles.spc_fitting,'Children');
for k=1:length(items)
    set(items(k),'Checked','off');
end
switch spc.fits{chan}.lastFitFunction
    case 'spc_fitexpgaussGY'
        set(handles.fit_single_gauss,'Checked','on');
    case 'spc_fitexp2gaussGY'
        set(handles.fit_double_gauss,'Checked','on');
    case 'spc_fitexpprfGY'
        set(handles.fit_single_prf,'Checked','on');
    case 'spc_fitexp2prfGY'
        set(handles.fit_double_prf,'Checked','on');
end
    


% --- Executes on button press in toExcelAndAdvance.
function toExcelAndAdvance_Callback(hObject, eventdata, handles)
spc_SaveFitToExcel;
spc_opennext_Callback([], eventdata, handles)

% --- Executes on button press in toExcel.
function toExcel_Callback(hObject, eventdata, handles)
spc_SaveFitToExcel;

% --------------------------------------------------------------------
function attachExcel_Callback(hObject, eventdata, handles)
spc_OpenExcelCOM;

% --------------------------------------------------------------------
function resaveAsTIFFstack_Callback(hObject, eventdata, handles)
% added GY 20110124 modified 20111201
global spc
[path name ext]=fileparts(spc.filename);
spc_saveAsTiffStack([path filesep name '.tif']);


% --- Executes on selection change in mainChanChoice.
function mainChanChoice_Callback(hObject, eventdata, handles)
% hObject    handle to mainChanChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mainChanChoice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mainChanChoice
chan=get(hObject,'Value');
% disp(['switching to channel ' num2str(chan) ' parameters']);
spc_FillGUIfromGlobals(chan);

% --- Executes during object creation, after setting all properties.
function mainChanChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mainChanChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function setGlobalGUIPairs(handles)
    global state FLIMchannels
    chanChoice={};
    for k=FLIMchannels
        if ~bitget(state.spc.FLIMchoices(k),3) % avoid calc'ed channels
            chanChoice{k}=num2str(k);
        end
    end
    set(handles.mainChanChoice,'String',chanChoice);
    nCh=max(FLIMchannels);
    defs={
        % {'guiName','globalprefix',#locs,'globalField'[,window#forMultiWin]} 
        {'beta1','spc.fits',nCh,'beta1'}
        {'beta2','spc.fits',nCh,'beta2'}
        {'beta3','spc.fits',nCh,'beta3'}
        {'beta4','spc.fits',nCh,'beta4'}
        {'beta5','spc.fits',nCh,'beta5'}
        {'beta6','spc.fits',nCh,'beta6'}
        {'fixtau1','spc.fits',nCh,'fixtau1'}
        {'fixtau2','spc.fits',nCh,'fixtau2'}
        {'fix_delta','spc.fits',nCh,'fix_delta'}
        {'fix_g','spc.fits',nCh,'fix_g'}
        {'F_offset','spc.switchess',nCh,'figOffset'}
        {'fix_delta','spc.fits',nCh,'fix_delta'}
        {'avgTau','spc.fits',nCh,'avgTau'}
        {'pop1','spc.fits',nCh,'pop1'}
        {'pop2','spc.fits',nCh,'pop2'}
        {'spc_fitstart','spc.fits',nCh,'fitstart'}
        {'spc_fitend','spc.fits',nCh,'fitend'}
        {'avgTauTrunc','spc.fits',nCh,'avgTauTrunc'}
        {'filename','spc',[],'filename'} % a single reference
        };
    spc_setGlobalGUIPairs(handles,defs);
    

% --- Executes on button press in toggleChanChoice.
function toggleChanChoice_Callback(hObject, eventdata, handles)
% hObject    handle to toggleChanChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FLIMchannels 
changeTo=[2 1 4 3 6 5];  % determines what toggling does
dropdown=handles.mainChanChoice;
chan=get(dropdown,'Value');
newChan=changeTo(chan);
if ~any(newChan==FLIMchannels)
    newChan=chan; % don't change to illegal value
end
set(dropdown,'Value',newChan);
mainChanChoice_Callback(dropdown,[],handles);


% --- Executes on selection change in sliceChooser.
function sliceChooser_Callback(hObject, eventdata, handles)
% hObject    handle to sliceChooser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sliceChooser contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sliceChooser
choice=get(hObject,'Value')-1;  % zero means sum; otherwise slice number
set(handles.slider1,'Value',-choice);
selectZslice(choice);

% --------------------------------------------------------------------
function varargout = slider1_Callback(h, eventdata, handles, varargin)
global spc
nMax=spc.datainfo.numberOfZSlices;
if nMax>1
    choice=-get(h,'Value');  % value is 0 for all, -N for slice N
    if choice<=nMax
       set(handles.sliceChooser,'Value',choice+1);
       selectZslice(choice);
    else
       choice=nMax;
       set(h,'Value',-nMax);
    end
else
    set(h,'Value',0);  % keep it at zero
end

function selectZslice(choice)
% in a multi Z slice file, copies and displays the selected slice
global spc FLIMchannels
if choice==0 % sum of all slices
    % we only get here if number of slices >=2
    for fc=FLIMchannels
        spc.imageMods{fc}=spc.imageModSlices{fc,1};
        for slice=2:spc.datainfo.numberOfZSlices
            spc.imageMods{fc}=spc.imageMods{fc}+spc.imageModSlices{fc,slice};
        end
    end
else % choice specifies the slice
    for fc=FLIMchannels
        spc.imageMods{fc}=spc.imageModSlices{fc,choice};
    end
end
spc_redrawSetting(1);  % recalc's projections, lifetimes, etc

function sliceChooser_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliceChooser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text18.
function text18_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over avgTauTrunc.
function avgTauTrunc_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to avgTauTrunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
