function [out,fname,pname,ext]=initGUIs(fileName, callCallbacks, file)
% opens and interprets and initialization file 
% 

% Author: Bernardo Sabatini 1/21/1
%

% variables
% 	currentStructure 	a string containing the name of structure to which we are currently
%						adding a field and gui parameters

	out=0;
	fname='';
	pname='';
	ext='';
	if nargin~=3
	% open file and read in by line ignoring comments
		fid=fopen(fileName, 'r');
		if fid==-1
			disp(['initGUIs: Error: Unable to open file ' fileName ]);
			return
		else
			out=1;
			[fullName, per, mf]=fopen(fid);
			fclose(fid);
			[pname, fname, ext]=fileparts(fullName);
		end
		file = textread(fullName,'%s', 'commentstyle', 'matlab', 'delimiter', '\n');
	end
		
	currentStructure=[];
	variableList={};
	
	lineCounter=0;
	while lineCounter<length(file)				% step through each line of the file
		lineCounter=lineCounter+1;
		tokens=tokenize(file{lineCounter});		% turn each line into a cell array of tokens (words)

		if ~isempty(tokens)	        		% are there words on this line?
            if strcmp(tokens{1}, '%')       % if comment line, skip it
            elseif strcmp(tokens{1}, 'structure')		% are we starting a new structure?
				if ~isempty(currentStructure)
					currentStructure=[currentStructure '.' tokens{2}];
				else
					currentStructure=tokens{2};
				end
				[topName, structName, fieldName]=structNameParts(currentStructure);	
				
				eval(['global ' topName ';']);		% get a global reference to the correct top level variable
				if ~exist(topName,'var')
					eval([topName '=[];']);
				end
				if ~isempty(fieldName)
					if ~eval(['isfield(' structName ',''' fieldName ''');'])
						eval([currentStructure '=[];']);
					end
				end
				
			elseif strcmp(tokens{1}, 'endstructure') 		% are we ending a structure?
				periods=findstr(currentStructure, '.');		% then trim currentStructure depending on whether it
				if any(periods)								% has any subfields
					currentStructure=currentStructure(1:periods(length(periods))-1);
				else
					currentStructure=[];
				end
				
			else											% it must be a fieldname[=val] [param, value]* line 
				fieldName=tokens{1};						% get fieldName
				
				startingValue=[];
				equ=findstr(fieldName, '=');				% is there a initialization value?
				tokenCounter=2;
				if any(equ)
					startingValue=fieldName(equ(1)+1:end);	% get initialization value
					fieldName=fieldName(1:equ(1)-1);		% get fieldname without init value
	                if isempty(startingValue)
                        startingValue=[];
                    elseif startingValue(1)==''''			% it's a string
						if (startingValue(end)~='''') || (length(startingValue)==1)
							done=0;
							while ~done
								startingValue=[startingValue ' ' tokens{tokenCounter}];
								if tokens{tokenCounter}(end)==''''
									done=1;
								end
								tokenCounter=tokenCounter+1;
								if (tokenCounter>length(tokens)) && ~done
									disp(['initGUIs: error in string initial value for ' fieldName]);
									done=1;
								end
							end
						end
					elseif startingValue(1)=='['		% it's a numeric array -- string arrays not supported
						if (startingValue(end)~=']') || (length(startingValue)==1)
							done=0;
							while ~done
								startingValue=[startingValue ' ' tokens{tokenCounter}];
								if tokens{tokenCounter}(end)==']'
									done=1;
								end
								tokenCounter=tokenCounter+1;
								if (tokenCounter>length(tokens)) && ~done
									disp(['initGUIs: error in array initial value for ' fieldName]);
									done=1;
								end
							end
						end
					elseif startingValue(1)=='{'		% it's a cell array -- only empty is supported
						if (startingValue(end)~='}') || (length(startingValue)==1)
							done=0;
							while ~done
								startingValue=[startingValue ' ' tokens{tokenCounter}];
								if tokens{tokenCounter}(end)==']'
									done=1;
								end
								tokenCounter=tokenCounter+1;
								if (tokenCounter>length(tokens)) && ~done
									disp(['initGUIs: error in array initial value for ' fieldName]);
									done=1;
								end
							end
						end

					else
						val=str2num(startingValue);
						if isempty(val) || ~isnumeric(val)
							if ~isempty(startingValue)
								if startingValue(1)~='''' | startingValue(end)~=''''
									startingValue=['''' startingValue ''''];
								end
							else
								startingValue='0';
							end
						end 
					end
				end

				if isempty(currentStructure)						% must be a global variable and not the field of a global
					fullVariableName=fieldName;
					eval(['global ' fullVariableName]);				% get access to the global
					if ~exist(fullVariableName,'var')				% if global does not exist...
						eval([fullVariableName '=' startingValue ';']);		% create it.
					elseif ~isempty(startingValue)>0					% if global exists and there is an init value ...
						eval([fullVariableName '=' startingValue ';']) 	% initialize global.
					end
				else												% we are dealing with the field of a global
					fullVariableName=[currentStructure '.' fieldName];
					if ~isempty(startingValue)>0											% if there is an init value ...
						eval([fullVariableName '=' startingValue ';']) 	% set it
					elseif ~eval(['isfield(' currentStructure ',''' fieldName ''');']) 	% if not, if field does not exist ...
						eval([fullVariableName '=[];'])					% initialize it
					end
				end

				variableList=[variableList, {fullVariableName}];
				validGUI=0;
                if length(tokens)>1
%					tokenCounter=2;
					while tokenCounter<length(tokens)							% loop through [param, value]* 
						param=tokens{tokenCounter};
						if strcmp(param, '...')					% continuation marker
							lineCounter=lineCounter+1;				% advance to next line in file
							tokens=tokenize(file{lineCounter});		% turn each line into a cell array of tokens (words)
							tokenCounter=1;
							param=tokens{tokenCounter};
						end
						value=tokens{tokenCounter+1};
                        if strcmp(param, '%')                       % found comment field. Skip line
                            break;
                        else                                        % not a comment line
                            if strcmp(param, 'Gui')						% special case for associating a GUI to a Global
			    				if ~existGlobal(value)
						    		disp(['initGUIs: GUI ' value ' for ' fullVariableName ' does not exist.  Skipping userdata...']);
                                else
			    					validGUI=1;
						    		addGUIOfGlobal(fullVariableName, value);
									try
	    								setUserDataByGUIName({value}, 'Global', fullVariableName);	
									catch
										error(['initGuis : setUserDataByGUIName gave error : ' fullVariableName ' ' value ' : ' lasterr]);
									end
				    			end
		    				elseif strcmp(param, 'Config')				% special case for labelling a global as part of a configuration
					    		setGlobalConfigStatus(fullVariableName, value);
							elseif strcmp(param, 'Database')
								addDBObservation(fullVariableName, value);
							else										% put everything else in UserData
			    				if validGUI==1
							    	vNum=str2num(value);
								    if isnumeric(vNum) && (length(vNum)==1)	% can it be a number?
    									value=vNum;							% yes, then make it a number
				    				end
									try
	    								setUserDataByGlobal(fullVariableName, param, value);	% put in UserData
									catch
										error(['initGuis : setUserDataByGlobal gave error : ' fullVariableName ' ' param ' : ' lasterr]);
									end
				    			end
    						end
                        end
						tokenCounter=tokenCounter+2;
					end
				end
				updateGUIByGlobal(fullVariableName);				% update all the GUIs that deal with the global variable
			end
		end
	end

	
	% Now execute all the callbacks that were collected during the processing of the
	% *.ini.  This ensures that everything is correct after the fields in the GUIs
	% have been changed by the initialization.
	
	if nargin<2
		callCallbacks=1;
	end
	
	if callCallbacks
		doneCallBacks=';;;';
		for i=1:length(variableList)
			entry=variableList{i};
			GUIList=getGuiOfGlobal(entry);
			if ~isempty(GUIList)
				for count=1:length(GUIList)
					GUI=GUIList{count};
					if ~isempty(GUI)
						[topGUI, sGui, fGui]=structNameParts(GUI);
						eval(['global ' topGUI]);
						funcName='';
						eval(['funcName=getUserDataField(' GUI ', ''Callback'');']);
						if ~isempty(funcName)
							if isempty(findstr(doneCallBacks, [';' funcName ';']))
								doneCallBacks=[doneCallBacks funcName ';'];
	%							disp(['DoGUICallback(' GUI ');']);		% for debugging
								eval(['DoGUICallback(' GUI ');']);
							end
						end
					end
				end
			end
		end
	end
	
			