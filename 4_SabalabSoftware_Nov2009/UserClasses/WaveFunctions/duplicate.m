function duplicate(wv,name)
% This is a wave class function.
% This is equivalent to saying name=wave, but waves do not supprot this assignment.
% Since waves are global , only one copy of a wave is allowed at a time.
% if name is the same as wave, then you must first use kill(wave) before recreating it.
% varargin are parameter value pairs passed to the wave constructor fucntion
% plot is not accepted, as each plot can be tied to only one wave.
% The converse is not true: a single wave can be tied to many plots.
% The exception is with XY plots.
% timeStamp is also unique to each wave.

if nargin < 2
    error('duplicate: Must supply a name and a wave for copy.')
end

if iswave(name)
	error('duplicate: Ouput wave already exists.  Use duplicateo to overwrite.');
end

duplicateo(wv,name);
