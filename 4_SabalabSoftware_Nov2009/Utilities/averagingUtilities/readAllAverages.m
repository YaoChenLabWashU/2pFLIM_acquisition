function readAllAverages
    global state
    
    for counter=0:7
        fileName=fullfile(state.files.savePath, ...
            [eval(['state.phys.settings.ADPrefix' num2str(counter)]) ...
				'_e*.mat']);
		files=dir(fileName);
		for fileCounter=1:length(files)
			fileName=files(fileCounter).name;
			per=find(fileName=='.');
			if ~isempty(per)
				fileName=fileName(1:per-1)
			end
			found=retreive(fileName);
			if evalin('base', ['isstruct(' fileName ')'])
				waveStruct=[];
				waveStruct=setfield(waveStruct, fileName, evalin('base', fileName));
				evalin('base', ['clear ' fileName]);
				loadWaveFromStructureo(waveStruct, fileName);
			end			
			
			if found
				evalin('base', ['plot(' fileName ');']);
				evalin('base', ['plotAvgComponents(' fileName ');']);
			end
			
		end
    end