function loadPulseSet(pname, fname)
	global state
	
	if nargin<2
		if ~isempty(state.pulses.pulseSetPath)
			try
				cd(state.pulses.pulseSetPath)
			catch
			end
		end
	
		[fname, pname]=uigetfile('*.mat', 'Choose pulse set');
	end

	if ~isnumeric(fname) & ~isempty(fname)
		if isempty(findstr(fname, '.'))
			fname=[fname '.mat'];
		end

		[fid, message]=fopen(fullfile(pname, fname));
		if fid<0
			disp(['loadPulseSet: Error opening pulseset file: ' message]);
			return
		end
		
		pulseSet=load(fullfile(pname, fname));
		pulseSet=pulseSet.pulseSet;
		fn=fieldnames(pulseSet);
				
		for counter=1:length(fn)
			if findstr('List', fn{counter})
				eval(['state.pulses.' fn{counter} '= pulseSet.' fn{counter} ';']);
			end
		end

        if length(state.pulses.patternRepeatsList)<length(state.pulses.durationList)
            state.pulses.patternRepeatsList(end+1:length(state.pulses.durationList))=0;
            state.pulses.patternISIList(end+1:length(state.pulses.durationList))=0;
        end
		disp(['*** LOADED PULSE SET ' fullfile(pname, fname) ' ***']);
		
		setPhysStatusString('pulseSet loaded');
		state.pulses.pulseSetChanged=0;

		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		end		
		state.pulses.pulseSetName = fname;
		state.pulses.pulseSetPath = pname;
		updateGUIByGlobal('state.pulses.pulseSetName');		
		changePulsePatternNumber(1);
	else
		setPhysStatusString('Cannot open file');
	end
	
	