function set(wv, varargin)
% set Fcn for classs wave
% Must be used as wave=set(wave, param, val) to change the wave.
% Easier to use wave.param=val.
% useful in functional form.
setWave(inputname(1),varargin{:});

