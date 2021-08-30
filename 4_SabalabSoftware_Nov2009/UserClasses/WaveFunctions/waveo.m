function done=waveo(waveName, waveData, varargin)

% WAVE class constructor that will overwrite wave if called.
% Calls wave constructor.
%
% wave(name,data, varargin) makes a global called name;
% in1 is the name of the wave to be created and in2 the data defined for that wave.
% ALL waves are global.
%
% done = 0 if unsuccessful, 1 if no wave existed, and 2 if a wave was removed before creating this wave.
%
% Plots are preserved by waveo, but bad handles are eliminated with each call to waveo.
%
% Include the path to the @wave file in the matlab file classpath.txt to make this class
% defined at matlab start.  This avoids conflicts with the methods not 
% being defined when loadWave/saveWave are called prior to the wave constructor.
%
% The @wave folder containing the methods must be placed in a folder on the matlab path, but
% it self cannot be on the path.
% 
% EXAMPLE:
% waveO('waveName', sin(1:10),...) creates a wave with name 'waveName' with the data sin(1:10) even one already existed.
%

done=0;
if ~ischar(waveName) & ~iscellstr(waveName)
	disp('waveo : First input must be a string or a cell array of strings');
	return
elseif any(isfunction(waveName))
	disp('waveo : wave name is a function name or keyword.  Please use a different name.');
	return
end

if ~iscellstr(waveName)
	waveCell={waveName};
else
	waveCell=waveName;
end

for waveCounter=1:length(waveCell)
	waveName=waveCell{waveCounter};
	if iswave(waveName)
		data=getWave(waveName);	% get the old data from the wave....
		done=2;
		if ~isempty(data.plot)	% there are some plots....
			evalin('base',[waveName '=[];']);	% kill without saying kill so wave won't error or remove the plots.
			plots=data.plot;
			plots=plots(ishandle(plots));	%remove bad plot handles...
			wave(waveName, waveData, ...
				'plot', plots, ...
				'timeStamp', data.timeStamp, ...
				varargin{:});	% Reassign the plots to the new wave.
            if ~getWave(waveName,'holdUpdates') 
			    updateWavePlots(waveName);
            end
		else
			kill(waveName);	
			wave(waveName, waveData, varargin{:});
		end
	else
		done=wave(waveName, waveData, varargin{:});	% Not a wave already so just make it.
	end
end

% % Parse input parameter pairs and rewrite values.
% counter=1;
% while counter+1 <= length(varargin)
% 	setWave(waveName, varargin{counter}, varargin{counter+1});
% 	counter=counter+2;
% end

