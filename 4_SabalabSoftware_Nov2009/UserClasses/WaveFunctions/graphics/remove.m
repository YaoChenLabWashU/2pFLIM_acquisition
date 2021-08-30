function remove(wv, varargin)
% Removes waves from plots
% wv must be a wave or a string of a wave name or cell array of wave names
% Supplying no axis handle removes plots from only current axis axes
% This function will alos remove links to the plto in other waves if they exist...e.g. like
% in a poltXY plot.

% can pass in axes
% can pass in firstOnly parameter (0 for all waves; 1 for first occurence) 
% can pass removeX (0 is default, 1 kills Xwaves also...)

if iscellstr(wv)
	if all(iscellwave(wv))
		waveCell=wv;
	else
		error('remove: 1st argument must be a wave,wave name, or cell array of wave names');
	end
elseif iswave(wv)
	if ~ischar(wv)
		waveCell = {inputname(1)};
	else
		waveCell={wv};
	end
else
	error('remove: 1st argument must be a wave,wave name, or cell array of wave names');
end

property_argin = varargin;
[ax,newAxes,f,allAx,property_argin]=getAxesInfo(property_argin);

firstOnly=1;
removeX=0;
% Parse input parameter pairs and rewrite values.
counter=1;
while counter+1 <= length(property_argin)
	eval([property_argin{counter} '=' num2str(property_argin{counter+1}) ';']);
	counter=counter+2;
end

% Format the children and parents into arrays.....
children=get(ax, 'Children');	% What lines are here ?
parent=get(ax, 'Parent');
if iscell(children) %More than one handle specified....
	childArray=[];
	parentArray=[];
	for i=1:length(children)
		childArray=[childArray; children{i}];
		parentArray=[parentArray; parent{i}];
	end
	parent=parentArray;
	children=childArray;
end

for waveCounter=1:length(waveCell)
	waveName=waveCell{waveCounter};
	plots=getWave(waveName, 'plot');
	found=0;
	for counter=1:length(children)
		if any(children(counter)==plots)	% the wave is in that plot
			userdata=get(children(counter), 'UserData');
			if strcmp(waveName, userdata.name{3}) | strcmp(waveName, userdata.name{2}) % it's the Y or Z wave, kill the plot
				found=1;
				userdata2.name={'' '' ''};
				userdata2.timeStamp=[0 0 0];
				set(children(counter), 'UserData', userdata2);
				delete(children(counter));
				for nameCounter=1:length(userdata.name)
					if ~isempty(userdata.name{nameCounter})
						newplots=getWave(userdata.name{nameCounter}, 'plot');
						f=find(newplots==children(counter));
						if ~isempty(f)
							newplots(f)=[];
							if isempty(newplots)
								newplots=[];
							end
							setWave(userdata.name{nameCounter}, 'plot', newplots);
						end
					end
				end
				% Only remove first occurrence  This si the default.
				if firstOnly == 1    
					break
				end
			elseif removeX==1 & strcmp(waveName, userdata.name{1})	% else is it's the X wave
				found=1;
				userdata2.name={'' '' ''};
				userdata2.timeStamp=[0 0 0];
				set(children(counter), 'UserData', userdata2);
				delete(children(counter));
				for nameCounter=1:length(userdata.name)
					if ~isempty(userdata.name{nameCounter})
						newplots=get(userdata.name{nameCounter}, 'plot');
						f=find(newplots==children(counter));
						if ~isempty(f)
							newplots(f)=[];
							if isempty(newplots)
								newplots=[];
							end
							setWave(userdata.name{nameCounter}, 'plot', newplots);
						end
					end
				end
				% Only remove first occurrence  This si the default.
				if firstOnly == 1    
					break
				end
			end
		end
	end
	%Update Figure Name if applicable....
	for parentCounter=1:length(parent)
		tempHandle=parent(parentCounter);
		if strcmp(get(tempHandle, 'NumberTitle'),'on')
			figName=get(tempHandle,'Name');
			indices=strfind(figName,waveName);
			if ~isempty(indices)
				figName(indices(1):indices(1)+length(waveName)-1)=[];
				set(tempHandle,'Name',figName);
			end
		end
	end
	if ~found & ~removeX
		disp(['remove : ' waveName ' not found on axes.  Maybe X wave. Set removeX to 1 to remove.']);
	end
end
