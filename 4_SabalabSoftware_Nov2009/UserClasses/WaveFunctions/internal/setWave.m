function setWave(waveName, varargin)
%set a wave property....

	if iswave(waveName)
        if ~ischar(waveName)
            waveName=inputname(1);
        end
	else
        error('setwave: input must be a wave or wavename');
	end

    if nargin >= 3
        doUpdate=1;
        if getWave(waveName, 'holdUpdates')
            doUpdate=0;
        else
            evalin('base',[waveName '.holdUpdates=1;']);
        end
        counter=1;
        while counter+1 <= length(varargin)
            val = varargin{counter+1};
            assignin('base','tempVal',val);
            evalin('base',[waveName '.' varargin{counter} '=tempVal;']);
            counter=counter+2;
        end
        if doUpdate
            if evalin('base',[waveName '.needsReplot;'])
                updateWavePlots(waveName);
            end
            evalin('base',[waveName '.holdUpdates=0;']);
        end
        evalin('base','clear(''tempVal'');');
    elseif nargin==2
        prop=varargin{1};
        str=displaySetValue(prop);
        if ~isempty(str)  
            disp(' ');
            disp(['    ' displaySetValue(prop)]);
            disp(' ');
        else
            disp(' ');
            disp(['    Cannot set value for ' prop]);
            disp(' ');
        end
    elseif nargin==1
        wavestruct=getWave(waveName);
        fn=fieldnames(wavestruct);
        disp('  ');
        for i=1:length(fn)
            str=displaySetValue(fn{i});
            if ~isempty(str)
                disp(['    ' str]);
            end
        end 
        disp('  ');
    else
        error('setwave : expect wavename and property as arguments');
    end

