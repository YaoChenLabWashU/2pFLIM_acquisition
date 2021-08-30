function [varargout]=loadWave(filename,wavename)
% laoding method for loading wave from disk
% Calls loadWaveFromStructure
% Pareses a structure into a wave
% Wave is automatically global
% wavename is a new wave name if desired...
% Waves have extension .mwf

if nargin == 0
	[fname, pname] = uigetfile('*.mwf', 'Choose Save Path and Name for Wave object...');
	if isnumeric(pname)
		return
	else
		filename = [pname fname];
	end
end

ext='';
[path,fname,ext]=fileparts(filename);
if isempty(ext)
    ext='.mwf';
end

if isempty(path)
    path=pwd;
end

out=load([path '\' fname ext],'-mat');
name=char(fieldnames(out));
out=getfield(out,name);

if nargin == 2
    name=wavename;
end

if iswave(name)
    error(['loadWave: wave ' name ' already exists.  Use loadWaveo to overwrite']);
end

waveo(name, out.data, ...
		'xscale', out.xscale, ...
		'yscale', out.yscale, ...
        'zscale', out.zscale,...
		'UserData', out.UserData, ...
		'note', out.note, ...
		'timeStamp', out.timeStamp);

if nargout == 1
	varargout{1}=out;
end
