function out=retreiveWave(waveName, savePaths, forcedisk)

	if nargin==1
		foundFile=retreive(waveName);
	elseif nargin==2
		foundFile=retreive(waveName, savePaths);
	elseif nargin==3
		foundFile=retreive(waveName, savePaths, forcedisk);
	end
	
	try
		if foundFile
			if evalin('base', ['isstruct(' waveName ')'])
				waveStruct=[];
				waveStruct=setfield(waveStruct, waveName, evalin('base', waveName));
				evalin('base', ['clear ' waveName]);
				loadWaveFromStructureo(waveStruct, waveName);
				out=1;
			end
		end
		if ~iswave(waveName)
			disp('retreiveWave : could not');
			out=0;	
		end
	catch
		disp('retreiveWave : could not');
		out=0;
	end
