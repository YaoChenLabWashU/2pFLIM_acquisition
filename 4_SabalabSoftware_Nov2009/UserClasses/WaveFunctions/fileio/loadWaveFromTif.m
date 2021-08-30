function varargout=loadWaveFromTif(filename, wavename, num)
% laoding method for loading a tif image into a wave...
% if the tif image is multi-tif, the number may be specified.
% If no wave name is supplied, the filename is used (no ext)
% if no number is supplied, one is by default.
% The header is placed intoo the wave UserData section.
% Wave is automatically global

if nargin == 0
	[fname, pname] = uigetfile('*.tif', 'Choose image to load as wave...');
	if isnumeric(pname)
		return
	else
		filename = [pname fname];
	end
end

if nargin < 3
    num=1;
end

ext='';
[path,fname,ext]=fileparts(filename);
if isempty(ext)
    ext='.tif';
end

if isempty(path)
    path=pwd;
end

if nargin<2
    name=fname;
else
    name=wavename;
end

if iswave(name)
    error(['loadWaveFromTif: wave ' name ' already exists.  Use loadWaveFromTifo to overwrite']);
end

out=imread([path '\' fname ext],num);
info = imfinfo([path '\' fname ext]);
waveo(name, out, 'UserData', struct(info));

if nargout == 1
	varargout{1}=out;
end
