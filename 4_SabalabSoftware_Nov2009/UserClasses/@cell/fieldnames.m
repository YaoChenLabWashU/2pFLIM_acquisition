function varargout=fieldnames(wv)
% returns fieldnames in UserData for a cell array of wave names

if nargin ~= 1
    error('fieldnames: A wave must be specified');
end

if ~all(iswave(wv))
    error('fieldnames: input must be a wave, wavename, or cell array of names');
end

ud=getWave(wv, 'UserData');
if ~iscell(ud)
    ud={ud};
end

for waveCounter=1:length(ud)
    out{waveCounter}=fieldnames(ud{waveCounter});
end

if length(out)==1
    out=out{1};
end

if nargout==1
    varargout{1}=out;
elseif nargout==0
    disp('    ');
	disp('ans = ');
	disp('    ');
	disp(out);
end
