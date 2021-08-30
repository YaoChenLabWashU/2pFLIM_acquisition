function duplicateo(wv,name)
% This is a wave class function.
% This is equivalent to saying name=wave, but waves do not supprot this assignment.
% Since waves are global , only one copy of a wave is allowed at a time.
% if name is the same as wave, then you must first use kill(wave) before recreating it.
% varargin are parameter value pairs passed to the wave constructor fucntion
% plot is not accepted, as each plot can be tied to only one wave.
% The converse is not true: a single wave can be tied to many plots.
% The exception is with XY plots.
% timeStamp is also unique to each wave.
% This clears any waves and plots witht eh wave in them.

if nargin < 2
    error('duplicateo: Must supply a name and a wave for copy.')
end

if iswave(wv)
    if ~ischar(wv)
        wv=inputname(1);
    end
else 
    error('duplicate: first argument must be a wave or the name of a wave');
end

wvprops=getWave(wv);
fn=fieldnames(wvprops);
waveo(name, wvprops.data,'holdUpdates',1,'needsReplot',0);
for counter=1:length(fn)
    prop=fn{counter};
	if ~any(strcmp(prop,{'plot' 'data' 'timeStamp' 'holdUpdates' 'needsReplot'})) 
		setWave(name, prop, getfield(wvprops, prop));
	end
end
setWave(name,'holdUpdates',0);
updateWavePlots(name);

% 
% wvprops=get(wv);
% fn=fieldnames(wvprops);
% vargs={'holdUpdates',1,'needsReplot',0};
% for counter=1:length(fn)
%     prop=fn{counter};
%     if ~any(strcmp(fn{counter},{'plot' 'data' 'timeStamp' 'holdUpdates' 'needsReplot'})) 
%         vargs=[vargs {fn{counter}} {getfield(wvprops,fn{counter})}];
%     end
% end    
% waveo(name, wvprops.data,vargs);
