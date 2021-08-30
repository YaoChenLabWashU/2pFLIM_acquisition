function pcellTest(chan)

		if nargin<1
			chan=1;
		end
		
		nLoops=3;
		
		global state
		disp('Running...')
	
        parkMirrors([0 0]);
        		
		state.pcell.pcellTestOut=[0:.01:2];
		state.pcell.pcellTestIn=zeros(1,size(state.pcell.pcellTestOut,2));
		
		state.pcell.pcellTestOut=repmat(state.pcell.pcellTestOut, [1, nLoops]);
		
		state.pcell.pCellTestOutObj = analogoutput('nidaq',state.pcell.pcellBoardIndex);		
		state.pcell.pCellTestOutChannel = addchannel(state.pcell.pCellTestOutObj, chan);

		state.pcell.pCellTestInObj = analoginput('nidaq',state.init.acquisitionBoardIndex);
		state.pcell.pCellTestInChannel = addchannel(state.pcell.pCellTestInObj, 2);
		
		for counter=1:size(state.pcell.pcellTestOut,2)
			putsample(state.pcell.pCellTestOutObj, state.pcell.pcellTestOut(counter));
			pause(0.001);
			state.pcell.pcellTestIn(1+mod(counter-1,size(state.pcell.pcellTestIn,2))) = ...
							state.pcell.pcellTestIn(1+mod(counter-1,size(state.pcell.pcellTestIn,2))) + ...
							getsample(state.pcell.pCellTestInObj);
		end
		state.pcell.pcellTestIn = state.pcell.pcellTestIn / nLoops;

        putsample(state.pcell.pCellTestOutObj, 0) ;          

        parkMirrors;
		disp('Done...')
