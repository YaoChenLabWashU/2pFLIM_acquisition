function killo(wv)
% Removes wave and plots;
% Use this function if you wish to remove wvs from pltos and then kill them.
% Note: This leaved plots logically updated.
if iscellstr(wv)
	if all(iscellwave(wv))
		waveCell=wv;
	else
		error('killo: 1st argument must be a wave,wave name, or cell array of wave names');
	end
elseif iswave(wv)
	if ~ischar(wv)
		waveCell = {inputname(1)};
	else
		waveCell={wv};
	end
else
	error('killo: 1st argument must be a wave,wave name, or cell array of wave names');
end

remove(waveCell,'axes','all','firstOnly',0,'removeX',1);   %Remove them all
for waveCounter=1:length(waveCell)
    waveName=waveCell{waveCounter};
	evalin('base',[waveName '=[];']);
	evalin('base', ['clear(''' waveName ''')']);
end




