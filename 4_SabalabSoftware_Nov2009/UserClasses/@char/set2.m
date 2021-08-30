function set(wavename, varargin)
% Overloaded method for classchar when the char represents a wave name.

if nargin >=3
    doUpdate=1;
    if get(wavename,'holdUpdates')
        doUpdate=0;
    else
        evalin('base',[wavename '.holdUpdates=1;']);
    end
    counter=1;
    while counter+1 <= length(varargin)
        val = varargin{counter+1};
        assignin('base','tempVal',val);
        evalin('base',[wavename '.' varargin{counter} '=tempVal;']);
        counter=counter+2;
    end
    if doUpdate
        if evalin('base',[wavename '.needsReplot;'])
            updateWavePlots(wavename);
        end
        evalin('base',[wavename '.holdUpdates=0;']);
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
    wavestruct=get(wavename);
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