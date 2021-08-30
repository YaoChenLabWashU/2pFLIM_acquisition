function reviewPhysAcq(n)

	global state
	
	if nargin<1
		n=state.files.reviewCounter;
	end
	
	if isempty(state.files.savePath)
		disp('*** reviewPhysAcq : No data save path set');
		setStatusString('SET SAVE PATH');
		
		return;
	end
	found=0;
	
	for counter=0:7
		try
			if getfield(state.phys.settings, ['acq' num2str(counter)])
				traceName=physTraceName(counter,n);
				foundFile=retreive(traceName, state.files.savePath);
				
				if foundFile
					if evalin('base', ['iswave(' traceName ')'])
						duplicateo(traceName, ['dataWave' num2str(counter)]);
						found=1;
					elseif evalin('base', ['isstruct(' traceName ')'])
						waveStruct=[];
						waveStruct=setfield(waveStruct, traceName, evalin('base', traceName));
						evalin('base', ['clear ' traceName]);
						loadWaveFromStructureo(waveStruct, traceName);
						duplicateo(traceName, ['dataWave' num2str(counter)]);
						found=1;
					else
						disp('*** reviewPhysAcq : found file but does not contain wave or readable struct ***');
					end
				else
					waveo(['dataWave' num2str(counter)], []);
				end
			end
		catch
		end
	end
	
	if ~found
		disp(['*** reviewPhysAcq: no files found for acq #' num2str(n) ' in ' state.files.savePath]);
	end
	