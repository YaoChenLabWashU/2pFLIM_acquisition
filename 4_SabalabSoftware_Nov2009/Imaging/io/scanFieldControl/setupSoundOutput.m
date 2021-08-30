function setupSoundOutput(dur)
global state

%TN 24Jul05

if nargin == 0
    dur=0.256;
    
end

state.sound.ao=analogoutput('winsound');

addchannel(state.sound.ao, 1:2);

set(state.sound.ao, 'SampleRate', 8192);

state.sound.t=[0:floor(8192*dur)];