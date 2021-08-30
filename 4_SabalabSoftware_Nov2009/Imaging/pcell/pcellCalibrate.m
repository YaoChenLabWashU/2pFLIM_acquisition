function pcellCalibrate(pcellNumber)
	global state
	
	if nargin<1
		pcellNumber=1;
	end
	
    calRange=300;    %range on coherent FieldmAx II
    maxCalVoltage=2;
    calFactor=calRange/maxCalVoltage;
    
	chan=pcellNumber-1;
	
    state.daq.pcellTestOutput = analogoutput('nidaq',state.pcell.pcellBoardIndex);		
	state.daq.pcellTestOutputChannel = addchannel(state.daq.pcellTestOutput, chan);

	state.daq.pcellTestInput = analoginput('nidaq',state.init.acquisitionBoardIndex);
	state.daq.pcellTestInputChannel = addchannel(state.daq.pcellTestInput, 3);
	
	state.pcell.pcellTestOut=[0:.02:2];
	state.pcell.pcellTestIn=zeros(1,length(state.pcell.pcellTestOut));
	
	numLoops=1;
	waveo('lastData', state.pcell.pcellTestIn);
	global lastData
	setWave(lastData, 'xscale', [0 0.02]);

	for repeatCounter=1:numLoops
		for counter=1:length(state.pcell.pcellTestOut)
			putsample(state.daq.pcellTestOutput, state.pcell.pcellTestOut(counter));
			pause(1);
			start(state.daq.pcellTestInput);
			while strcmp(get(state.daq.pcellTestInput, 'Running'), 'On')
				pause(0.01);
			end		
			data=getdata(state.daq.pcellTestInput);
			power=mean(data)*calFactor;

			[state.pcell.pcellTestOut(counter) power]
			state.pcell.pcellTestIn(counter)=state.pcell.pcellTestIn(counter)+power/numLoops;
			lastData.data(counter)=state.pcell.pcellTestIn(counter);
		end
	end
    putsample(state.daq.pcellTestOutput, 0) ;          

	eval(['state.pcell.pcellPowerCal' num2str(pcellNumber) '=state.pcell.pcellTestIn;']);

	disp('Done...')
