function power=gyPowerTest
global aiGY 
seconds=2;
if isempty(aiGY)
    aiGY=analoginput('nidaq','Dev2');
    gyTemp=addchannel(aiGY,5);
end
set(aiGY,'SampleRate',2000);
set(aiGY,'SamplesPerTrigger',seconds*2000);
start(aiGY);
wait(aiGY,seconds+1); pdata=getdata(aiGY,seconds*2000);
power=620/2*mean(pdata)+2.6;
power=floor(100*power+0.5)/100;
% disp(['Power = ' num2str(power)]);

