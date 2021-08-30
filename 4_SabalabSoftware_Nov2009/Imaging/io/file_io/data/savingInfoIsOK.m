function out=savingInfoIsOK(physOnly)
%updated by tp 10/25/01

	global state
	if state.files.autoSave==0			% BSMOD2
		out=1;
		disp([clockToString(clock) ' *** Acquiring with auto saving off ***']);
		return
	end		

	out=0;
	if nargin<1 
		physOnly=0;
	end
	if ~physOnly & isempty(state.files.baseName) %if no base name is chosen
		 answer  = inputdlg('Select base name','Choose Base Name for Acquisition',1,{state.files.baseName});
         if ~isempty(answer)
			state.files.baseName = answer{1};
			updateGUIByGlobal('state.files.baseName');
		 else
			disp('*** ERROR: Please enter a basename ***')
			beep;
			setStatusString('Enter Basename');
			return
         end
	end
	if isempty(state.files.savePath)
		button = questdlg('A Save path has not been selected.','Do you wish to:','Select New Path','Cancel','Select New Path');
        if strcmp(button,'Select New Path')
            setSavePath;
		end
	end
	if isempty(state.files.savePath)
		disp('*** ERROR: Please set a save path using save ''File\Header Structure As...'' ***');
		setStatusString('Select Save Path');
		beep;
		return
	end

	updateFullFileName;
	disp([clockToString(clock) ' *** '''  state.files.fullFileName ''' ***']); 
	out=1;
	
		
		
		