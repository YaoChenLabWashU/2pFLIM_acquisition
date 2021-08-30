function done=wave(waveName, data, varargin)
% WAVE class constructor.
%
% wave(name,data, varargin) makes a global called name;
% in1 is the name of the wave to be created and in2 the data defined for that wave.
% ALL waves are global.
%
% varargin are parameter value pairs.  Valid parameters are note, plot, UserData, and scale.
% Scale must be a row vector with 2 columns e.g. [xstart deltax]
% note is a string
% plot is the handle to a plot.
% UserData can have any data structure. A structure array is recommended for easy parsing.
%
% Include the path to the @wave file in the matlab file classpath.txt to make this class
% defined at matlab start.  This avoids conflicts with the methods not 
% being defined when loadWave/saveWave are called prior to the wave constructor.
%
% The @wave folder containing the methods must be placed in a folder on the matlab path, but
% it self cannot be on the path.
% 
% EXAMPLE:
% wave('waveTest', sin(1:10)) creates a wave with name w with the data sin(1:10)
%
% done = 1 if successful, 0 otherwise.

done=0;
if ~ischar(waveName) & ~iscellstr(waveName)
	error('wave : 1st input must be a wave name or cell array -- i.e. a string');
elseif any(isfunction(waveName)) 
	error('wave : wave name is a function name or keyword or less than 2 characters.  Please use a different name.');
elseif ischar(waveName) & length(waveName)<2
	error('wave : wave name is a function name or keyword or less than 2 characters.  Please use a different name.');
end

if nargin<2
	error('wave : wave name and numeric data must be supplied as input.');
end

if any(iswave(waveName))
	error(['wave : Wave with name for inputs names already exists.']);
end

if ~isnumeric(data)
	error('wave : 2nd input must be numeric data for wave.');
end

if numdims(data) > 3
	error('wave: data must be a vector or matrix.');
end

if size(data,1) > 1 & ndims(data) > 1 & size(data,2) == 1
   data = data';
end

if ~iscellstr(waveName)
	waveCell={waveName};
else
	waveCell=waveName;
end

for waveCounter=1:length(waveCell)
	waveName=waveCell{waveCounter};
	if length(waveName) <= 2
		error('wave : All wavenames must be longer than 2 character.');
	end
end

UserDataStructure.info='';

out.data=data;
out.xscale=[0 1];
out.yscale=[0 1];
out.zscale=[1 size(data,3)];   %now used for 3D waves....stacks of images.
out.plot=[];
out.UserData=UserDataStructure;
out.note='';
out.timeStamp = etime(clock,[2001 1 1 0 0 0 ])+rand(1)/1000;
out.holdUpdates=0;
out.needsReplot=0;

% Parse input parameter pairs and rewrite values.
counter = 1;
while counter+1 <= length(varargin) 
	prop = varargin{counter};
	val = varargin{counter+1};
	switch prop
		case 'xscale'
			if isnumeric(val) & size(val,1) == 1 & size(val,2) == 2
                out=setfield(out,prop,val);
			else
				error('wave: Invalid value for xscale. Scale must be a row vector with 2 columns e.g. [xstart deltax]. Skipping.');
			end
		case 'yscale'
			if isnumeric(val) & size(val,1) == 1 & size(val,2) == 2
			    out=setfield(out,prop,val);
			else
				error('wave: Invalid value for yscale. Scale must be a row vector with 2 columns e.g. [xstart deltax]. Skipping.');
			end
		case 'zscale'
			if isnumeric(val) & size(val,1) == 1 & size(val,2) == 2
			    out=setfield(out,prop,val);
			else
				error('wave: Invalid value for zscale. Scale must be a row vector with 2 columns e.g. [xstart deltax]. Skipping.');
			end
		case 'plot'
			if all(ishandle(val))
                out=setfield(out,prop,val);
			else
				error('wave: Invalid value for plot. plot must be a vector of handles. Skipping.');
			end
		case 'UserData'
            if ~isstruct(val)
				error('wave: Invalid value for UserData. UserData must be a structure. Skipping.');
            end
             out=setfield(out,prop,val);
        case 'holdUpdates'
            if val==0 | val==1
                 out=setfield(out,prop,val);
             else
                 error('wave: Invalid value for holdUpdates. holdUpdates must be a 1 or 0. Skipping.');
             end 
        case 'needsReplot'
            if val==0 | val==1
                 out=setfield(out,prop,val);
             else
                 error('wave: Invalid value for needsReplot. needsReplot must be a 1 or 0. Skipping.');
             end 
		case 'timeStamp'
			out=setfield(out,prop,val);
		case 'note'
			if ischar(val) 
				out=setfield(out,prop,val);
			else
				error('wave : Invalid value for note. Note must be a character (string) or structure. Skipping.');
			end
		otherwise
			error('wave : Invalid property for wave. Properties are plot, UserData, note, and scale.')
	end
	counter=counter+2;
end

out = class(out, 'wave');
% Declare wave as a global and publish to workspace.

for waveCounter=1:length(waveCell)
	waveName=waveCell{waveCounter};
	if length(waveName) < 2 | ~isempty(strfind(waveName,' '))
		error('wave : All wavenames must be longer than 2 character with no blank spaces.');
	end
	if isstruct(out.UserData)
		out.UserData.name=waveName;
	end
	evalin('base', ['global ' waveName]);
	assignin('base', waveName, out);
	% checkForOldPlots(waveName);
end
done=1;