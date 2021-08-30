function loadBlasterSetup(pname, fname)

	global state gh
	setStatusString('Loading blaster setup...');

	if nargin<2
		if ~isempty(state.blaster.setupPath)
			try
				cd(state.blaster.setupPath);
			catch
			end			
		end
		
		[fname, pname]=uigetfile('*.mat', 'Choose blaster setup file to load');
	end
    
try

	if ~isnumeric(fname) && ~isempty(fname)
		blaster=load(fullfile(pname, fname), '-MAT');
		fnames=fieldnames(blaster.blaster);
		for counter=1:length(fnames)
			eval(['state.blaster.' fnames{counter} ' = blaster.blaster.' fnames{counter} ';']);
		end
		state.blaster.setupName=fname;
		state.blaster.setupPath=pname;
		state.blaster.currentConfig=max(state.blaster.currentConfig, 1);
		state.blaster.displayConfig=state.blaster.currentConfig;
		updateBlasterConfigDisplay
		makeBlasterConfigMenu
		state.blaster.displayPos=1;
		updateGUIByGlobal('state.blaster.displayPos');
		state.blaster.X = state.blaster.XList(state.blaster.displayPos);
		updateGUIByGlobal('state.blaster.X');
		state.blaster.Y = state.blaster.YList(state.blaster.displayPos);
		updateGUIByGlobal('state.blaster.Y');
		updateGUIByGlobal('state.blaster.prePark');
		updateGUIByGlobal('state.blaster.widthFromPattern');
		updateGUIByGlobal('state.blaster.powerFromPattern');
		updateGUIByGlobal('state.blaster.active');
		updateGUIByGlobal('state.blaster.screenCoord');
		setStatusString('Blaster setup loaded');
		disp(['*** CURRENT BLASTER SETUP FILE IS ' fullfile(pname, fname) ' ***']);
		
	else
		setStatusString('Cannot load blaster setup');
	end
	
catch 
    disp(['*** ERROR LOADING BLASTER SETUP ***']);
	disp(lasterr);
	setStatusString('Cannot load blaster setup');

end