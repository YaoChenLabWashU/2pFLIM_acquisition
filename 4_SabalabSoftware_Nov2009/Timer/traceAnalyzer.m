function varargout = traceAnalyzer(varargin)
% TRACEANALYZER M-file for traceAnalyzer.fig
%      TRACEANALYZER, by itself, creates a new TRACEANALYZER or raises the existing
%      singleton*.
%
%      H = TRACEANALYZER returns the handle to a new TRACEANALYZER or the handle to
%      the existing singleton*.
%
%      TRACEANALYZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACEANALYZER.M with the given input arguments.
%
%      TRACEANALYZER('Property','Value',...) creates a new TRACEANALYZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before traceAnalyzer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to traceAnalyzer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help traceAnalyzer

% Last Modified by GUIDE v2.5 24-Sep-2009 16:24:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @traceAnalyzer_OpeningFcn, ...
                   'gui_OutputFcn',  @traceAnalyzer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before traceAnalyzer is made visible.
function traceAnalyzer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to traceAnalyzer (see VARARGIN)

% Choose default command line output for traceAnalyzer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes traceAnalyzer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function varargout = traceAnalyzer_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;




%*****************


function active_Callback(hObject, eventdata, handles)
	genericCallback(hObject);

function displayLine_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	updateLineDisplay;
	
function displayPeak_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	updatePeakDisplay;
	
function channelSelection_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	state.analysis.setup{state.analysis.displayLine, 1}=state.analysis.channelSelection;
	
function pulsePattern_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	state.analysis.setup{state.analysis.displayLine, 2}=state.analysis.pulsePattern;

function roiSelection_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	state.analysis.setup{state.analysis.displayLine, 3}=state.analysis.roiSelection;

function baselineMode_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	state.analysis.setup{state.analysis.displayLine, 4}=state.analysis.baselineMode;

function baselineStart_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	state.analysis.setup{state.analysis.displayLine, 5}=state.analysis.baselineStart;

function baselineEnd_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	state.analysis.setup{state.analysis.displayLine, 6}=state.analysis.baselineEnd;

function peakMode_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	state.analysis.setup{state.analysis.displayLine, 7}(state.analysis.displayPeak, 1)=state.analysis.peakMode;

function peakStart_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	state.analysis.setup{state.analysis.displayLine, 7}(state.analysis.displayPeak, 2)=state.analysis.peakStart;

function peakEnd_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	state.analysis.setup{state.analysis.displayLine, 7}(state.analysis.displayPeak, 3)=state.analysis.peakEnd;

function deleteLine_Callback(hObject, eventdata, handles)
	global state
	state.analysis.setup(state.analysis.displayLine, :)=[];
	if size(state.analysis.setup, 1)==0
		state.analysis.setup={1 0 1 1 0 0 [1 0 0] {}};
		state.analysis.displayLine = 1;
		updateGUIByGlobal('state.analysis.displayLine')
	elseif state.analysis.displayLine > size(state.analysis.setup, 1)
		state.analysis.displayLine = size(state.analysis.setup, 1);
		updateGUIByGlobal('state.analysis.displayLine')
	end
	updateLineDisplay
	
function deletePeak_Callback(hObject, eventdata, handles)
	global state

	state.analysis.setup{state.analysis.displayLine, 7}(state.analysis.displayPeak, :)=[];
	
	if size(state.analysis.setup{state.analysis.displayLine, 7}, 1)==0
		state.analysis.setup{state.analysis.displayLine, 7}=[1 0 0];
		state.analysis.displayPeak = 1;
		updateGUIByGlobal('state.analysis.displayPeak')
	elseif state.analysis.displayPeak > size(state.analysis.setup{state.analysis.displayLine, 7}, 1)
		state.analysis.displayPeak = size(state.analysis.setup{state.analysis.displayLine, 7}, 1);
		updateGUIByGlobal('state.analysis.displayPeak')
	end
	updatePeakDisplay

function baselinePlot_Callback(hObject, eventdata, handles)
	tracePlot(1, 0);

function baselineAppend_Callback(hObject, eventdata, handles)
	tracePlot(0, 0);

function peakPlot_Callback(hObject, eventdata, handles)
	tracePlot(1, 1);

function peakAppend_Callback(hObject, eventdata, handles)
	tracePlot(0, 1);

function generic_Callback(hObject, eventdata, handles)
	genericCallback(hObject);

function rerunButton_Callback(hObject, eventdata, handles)
	global state
	runFluorAnalysis(state.files.lastAcquisition);

function selectROIButton_Callback(hObject, eventdata, handles)
	global state gh
	if state.analysis.analysisMode==1
		beep;
		disp('*** please select an analysis mode first ***');
		setStatusString('SELECT analysis mode');
		return
	end
	set(hObject, 'Enable', 'off');	
	try
		set(gh.traceAnalyzer.selectROIButton, 'ForeGroundColor', [0 0 1]);
		setStatusString('Drag over ROI');
	
		siSelectionChannelToFront

		k = waitforbuttonpress;
	
		if isempty(findobj(gcf, 'Type', 'axes'))
			disp('*** NO axes***');
			set(hObject, 'Enable', 'on');	
			set(gh.traceAnalyzer.selectROIButton, 'ForeGroundColor', [0 0 0]);
			return
		end
		
		point1 = get(gca,'CurrentPoint');    % button down detected
		finalRect = rbbox;                   % return figure units
		set(gh.traceAnalyzer.selectROIButton, 'ForeGroundColor', [0 0 0]);
		setStatusString('');
	
		point2 = get(gca,'CurrentPoint');    % button up detected
		point1 = point1(1,1:2);              % extract x and y
		point2 = point2(1,1:2);
		p1 = min(point1,point2);             % calculate locations
		offset = abs(point1-point2);         % and dimensions
		x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
		y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
		x=round(x);
		y=round(y);
		hold on;
		axis manual;
	
		if (state.analysis.analysisMode==2) | (state.analysis.analysisMode==4 & state.acq.lineScan)
			state.analysis.roiDefs(state.analysis.currentROINumber, :)=[x(1) x(2)];
			waveo(['roi_' num2str(state.analysis.currentROINumber) 'x'], x(1)-1);
			waveo(['roi_' num2str(state.analysis.currentROINumber) 'y'], x(2)-1);
			
		elseif (state.analysis.analysisMode==3) | (state.analysis.analysisMode==4 & ~state.acq.lineScan)
			state.analysis.roiDefs2D(state.analysis.currentROINumber, :)=[x(1) x(2) y(1) y(3)];
		end
	catch
		disp(['ROI selection error : ' lasterr]);
	end
	set(hObject, 'Enable', 'on');


function collapseButton_Callback(hObject, eventdata, handles)
	global gh
	p=get(gh.traceAnalyzer.figure1, 'Position');
	if p(4)<20
		p(4)=39.9;
		p(2)=p(2)-39.9+16;
		set(gh.traceAnalyzer.collapseButton, 'Position', [55 29 4.8000 1.7692])		
	else
		p(4)=16;
		p(2)=p(2)+39.9-16;
		set(gh.traceAnalyzer.collapseButton, 'Position', [55 1.2 4.8 1.7692])		
	end
	
	set(gh.traceAnalyzer.figure1, 'Position', p)


% --------------------------------------------------------------------
function Untitled_13_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in saveAvgLinescan.
function saveAvgLinescan_Callback(hObject, eventdata, handles)
% hObject    handle to saveAvgLinescan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveAvgLinescan
