function varargout=settingsManager(varargin)
	action=varargin{1};
	 
	persistent setValues setNames setVariables
	if ~iscell(setValues)
		setValues={};
		setNames={};
		setVariables={};
		savePaths={};
		saveFiles={};
	end
	
	if ischar(action)
		switch lower(action)
			case 'report'	% actions 0-9 are for initializing and gettings info on the sets
				action=0;
			case 'init'		
				action=1;
			case 'getsetlength'
				action=2;
			case 'store'	% actions 10-19 are for storing data in the sets
				action=10;
			case 'storeone'
				action=11;
			case 'recall'	% actions 20-29 are for extracting data and recalling data from the set
				action=20;
			case 'recallone'
				action=21;
			case 'extractval'
				action=22;
			case 'refresh'	% actions 30-39 are for refreshing the displayed data
				action=30;
			case 'refreshone'
				action=31;
			case 'savetofile'	% actions 40-49 are for file i/o
				action=40;
			case 'readfromfile'
				action=41;
			otherwise
				disp('*** Error: settingsManager : Unknown action.  ***');
				return
		end
	end

	if action==0 % return contents of persistent varaibles for debugging
		varargout={setNames, setVariables, setValues};
		return
	end

	currentSetName=varargin{2};
	if action==1 % initialize
		% argument order is action, setName, setVariableList 
		currentSetVariableList=varargin{3};
		setPosition=find(strcmp(setNames, currentSetName));
		if isempty(setPosition)
			setNames{end+1}=currentSetName;
			setPosition=length(setNames);
		end
		setVariables{setPosition}=currentSetVariableList;
		setValues{setPosition}={};
		savePath{setPosition}={};
		saveFolder{setPosition}={};
		savePosition=1;
		pickedVariable=1:length(setVariables{setPosition});
	else
		setPosition=find(strcmp(setNames, currentSetName));
		if isempty(setPosition)
			disp('*** Error: settingsManager : Position not found.  Need to init before use ***');
			return
		end
		if action>=10		% the lower actions work on entire sets and do not need a position arguments
			savePosition=varargin{3};
		end
		if any(action==[11 21 22 31]) 	% the action is on 1 variable alone
			pickedVariable=find(strcmp(setVariables{setPosition}, varargin{4}));
			if isempty(pickedVariable)
				disp(['settingsManager : ' varargin{4} ' not in variable list']);
				varargout{1}=[];
				return
			end
		else	% the action is on the entire variable set
			pickedVariable=1:length(setVariables{setPosition});
		end
	end

	if action==2		% return the length of the set
		varargout{1}=size(setValues{setPosition}, 1);
	elseif any(action==[1 10 11]) % actions that store information
		for counter=pickedVariable
			setValues{setPosition}{savePosition, counter}=evalin('base', setVariables{setPosition}{counter});
		end
	elseif any(action==[20 21]) % actions that recall information
		if savePosition<1 | savePosition>size(setValues{setPosition}, 1)
			disp('settingsManager : Recall out of range');
			return
		end
		for counter=pickedVariable
			assignin('base', 'smTempVar', setValues{setPosition}(savePosition, :));
			evalin('base', [setVariables{setPosition}{counter} '=smTempVar{' num2str(counter) '};'])
			updateGUIByGlobal(setVariables{setPosition}{counter});
		end
	elseif action==22 	% actions that extract and return values
		if savePosition<1 | savePosition>size(setValues{setPosition}, 1)
			disp('settingsManager : Recall out of range');
			return
		end
		varargout{1}=setValues{setPosition}{savePosition, pickedVariable};
	elseif any(action==[30 31])	% actions that refresh
		for counter=pickedVariable
			updateGUIByGlobal(setVariables{setPosition}{counter});
		end			
	elseif action==8 
		varargout{1}=setValues{setPosition}{pickedVariable};
	elseif any(action==[40 41]) % file i/o
		'file i/o not implemented'
	end
