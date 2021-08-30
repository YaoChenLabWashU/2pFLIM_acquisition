function saveWave(obj, filename)
% saving method for saving wave to disk
% Saves as a mat file with extension .mwf
% Accepst in a character obj or the actual wave.

if nargin < 2
    error('saveWave: must supply wave name and filename.')
end

if ~iswave(obj)
	error('saveWave: obj must be a wave object.')
elseif ~ischar(obj)
    obj=inputname(1);
end
eval([obj '=get(obj);']);

ext='';
[path,name,ext]=fileparts(filename);
if isempty(ext)
    ext='.mwf';
end
save(fullfile(path,[name ext]),obj,'-mat');

%try
    
%    if(state.db.conn~=0)
%            state.db.oid=storeWaveDB(obj);
%    end
%catch
%    disp(['Error in saving wave to database : ' lasterr]);
%end