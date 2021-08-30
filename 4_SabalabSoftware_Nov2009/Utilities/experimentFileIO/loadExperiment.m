function loadExperiment(filename, pathname)
	if nargin<2
		[filename, pathname] = uigetfile('*.mat', 'Select experiment to load...');
	end
	if isempty(filename) || isnumeric(filename)
		return;
	end
	
	global state gh
	oldState=state;
	oldGh=gh;
	
	cd(pathname);
	disp('Loading workspace...');
	evalin('base', ['load(''' fullfile(pathname, filename) ''');']);

	global savedFigureList
	evalin('base', 'global savedFigureList');
	try
		loadFigures(savedFigureList);
	catch
		loadFigures;
	end

	try
		oldState.files.savePath=state.phys.settings.dataSavePath;
		oldState.files.fileCounter=state.phys.counter;
	catch
	end
	
	try
		oldState.files=state.files;
	catch
	end
		
	try
		oldState.notebook=state.notebook;
	catch
	end
	
	try
		oldState.phys=state.phys;
	catch
	end
	
	global state gh
	state=oldState;
	gh=oldGh;
	
	disp('Updating GUIs...  PLEASE BE PATIENT');
	updateGuiByStruct('state');

	disp(['*** LOADED EXPERIMENT ' filename '***']);
	global state
	if exist('state')
		if isfield(state, 'analysisMode')
			state.analysisMode=1;
		end
		if isfield(state, 'notebook')
			if isfield(state.notebook, 'notebookText1')
				if iscell(state.notebook.notebookText1) | iscell(state.notebook.notebookText2)
					updateNotebookDisplay;
				end
			end
		end
	end
	