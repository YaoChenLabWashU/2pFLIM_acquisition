function varargout = showWaves(handle,dim,varargin)
% This function will output a cell array of strings
% with the names of all the wave objects.
% If no handle is specified, it returns all waves in workspace. 
% If a handle is supplied, it returns all the waves on the handle.
% Valid handles are images, lines, axes, and figures.
% handles can be a vector of handles.
%
% New and improved...TP 2/15/03
% Replaces all show functions....
% If just one input and it is not a figure handle, then shows all 
% with that dimension.
% 'all' means on all figures
% 'every' means for all waves on or off plots...

out={};
a=[];
if nargin < 2
	dim=2;
end

%Parse inputs....
if nargin == 0  %Show all waves as output
	    out=getWavesFromBase;
elseif nargin >= 1  %passed a handle
	if istype(handle,'figure') | istype(handle,'axes') | istype(handle,'image') | istype(handle,'line')
		a = [findobj(handle, 'Type', 'line'); findobj(handle, 'Type', 'image')];	% Get all plots and images
	elseif ischar(handle) & strcmp(handle,'all') 
		a = [findobj('Type', 'line'); findobj('Type', 'image')];	% Get all plots and images
	elseif ischar(handle) & strcmp(handle,'every') 
		out=getWavesFromBase;
		wavesize=waveSize(out);	%returns array...
		if dim == 1
			out=out(find(wavesize(:,1)==1 | wavesize(:,2)==1));
		elseif dim == 2 | dim==3
			out=out(find(wavesize(:,1) > 1 & wavesize(:,2) > 1));
		else
			error('showWaves: dim must be 1,2, or 3');
		end
	else
		error('showWaves: input must be a handle or array of handles of the SAME type: figure, axes, image, or axes.');
	end
end

if ~isempty(a)
	userdata = get(a, 'UserData'); % Look in UserData.
	if ~iscell(userdata)
		userdata={userdata};
	end
	for i = 1:length(a)	   
		if isfield(userdata{i}, 'name')
            nameCell=userdata{i}.name(dim);
			for name=nameCell
				if ~isempty(name{1})
					out{end+1}=name{1};
				end
			end
		end
	end
end

forceunique=0;
% Parse input parameter pairs and rewrite values.
counter=1;
while counter+1 <= length(varargin)
    eval([varargin{counter} '=' num2str(varargin{counter+1}) ';']);
    counter=counter+2;
end

% %Sort and remove redundancy
if forceunique
    out=unique(out);
end

%Parse Varargouts....
if nargout==1
	varargout{1}=out;
else
	disp('    ');
	disp('ans = ');
	disp('    ');
	disp(out');
end

function out=getWavesFromBase
    % gets all the wave objects from base.
    everything=evalin('base','whos');
	[everyClass{1:length(everything)}]=deal(everything(:).class);
	[everyName{1:length(everything)}]=deal(everything(:).name);
	out=everyName(strcmp(everyClass,'wave'));