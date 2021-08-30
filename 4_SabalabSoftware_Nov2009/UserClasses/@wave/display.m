function display(wv)

% WAVE/DISPLAY Command window display of a wave
% updated for the new logic.
disp(' ');
disp([inputname(1),' = '])
disp(' ');
disp(getWave(inputname(1)));
