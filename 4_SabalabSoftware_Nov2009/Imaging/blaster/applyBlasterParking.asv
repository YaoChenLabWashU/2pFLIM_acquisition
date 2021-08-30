function applyBlasterParking(config)
    global state

	if state.blaster.currentConfig<1
		state.blaster.currentConfig=1;
	end
	
    if nargin<1
        config=state.blaster.currentConfig;
    end
    config=max(config,1);
	
    
    parkParams=[];	%each row [startPark endPark X Y]
    
    % below we gather all of the times that the laser must be parked, sort
    % them, and then apply them in reverse order.  This ensures that later
    % pulse do not obliterate early ones
    
    if size(state.blaster.allConfigs{config, 2},2) == 6 % there are 6 entries 
                                                        % in the line indicating that it 
                                                        % is a properly defined blaster position
        for lineCounter=1:size(state.blaster.allConfigs{config, 2},1)
            pulseNumber=state.blaster.allConfigs{config, 2}(lineCounter, 2);
            if pulseNumber
                pos=state.blaster.allConfigs{config, 2}(lineCounter, 1);
                if state.blaster.indexList(pos)
                    if state.blaster.screenCoord
                        if state.blaster.allConfigs{config, 2}(lineCounter, 6)	% use the tiler for this position
                            state.blaster.indexList(pos)=state.blaster.tileIndexList(state.blaster.tileCounter);
                            state.blaster.posUsingTiler=pos;
                        end
                        X=state.acq.rotatedMirrorData2D(state.blaster.indexList(pos), 1);
                        Y=state.acq.rotatedMirrorData2D(state.blaster.indexList(pos), 2);
                        state.blaster.XList(pos)=X;
                        state.blaster.YList(pos)=Y;
                        if pos==state.blaster.displayPos
                            state.blaster.X=X;
                            state.blaster.Y=Y;
                            updateGUIByGLobal('state.blaster.X');
                            updateGUIByGLobal('state.blaster.Y');
                        end
                    else
                        X=state.blaster.XList(state.blaster.displayPos);
                        Y=state.blaster.XList(state.blaster.displayPos);
                    end
                else
                    setStatusString('Blaster pos not defined');
                    error(['applyBlasterParking : Blaster position #' num2str(pos) ' not defined']);
                end
                
                if state.blaster.widthFromPattern
                    width=state.pulses.pulseWidthList(pulseNumber);
                else
                    width=state.blaster.allConfigs{config, 2}(lineCounter, 3);
                end
                
                % 				if state.blaster.powerFromPattern
                % 					power=state.pulses.amplitudeList(pulseNumber);
                % 				else
                % 					power=state.blaster.allConfigs{config, 2}(lineCounter, 4);
                % 				end
                try
                    for patternCounter=1:max(state.pulses.patternRepeatsList(pulseNumber), 1)
                        start=state.pulses.delayList(pulseNumber) + (patternCounter-1)*state.pulses.patternISIList(pulseNumber);
                        for counter=1:state.pulses.numPulsesList(pulseNumber)
                            parkParams(end+1, :) = [...
                                start-state.blaster.prePark start+width  X Y];
                            start=start + state.pulses.isiList(pulseNumber);
                        end
                    end	
                catch
                    disp('*** Error in applyBlasterParking.  Physiology must be loaded to use blaster');
                    error(['applyBlasterParking : ' lasterr]);
                end
            end
        end
    else
        beep;
        disp('*** Error in applyBlasterParking.  blaster positions are not fully defined');
    end		

    if ~isempty(parkParams)
        acqLength=state.acq.msPerLine*state.acq.linesPerFrame*state.acq.numberOfFrames; 	% in ms
        parkParams=sortRows(parkParams);
        for counter=size(parkParams,1):-1:1
            if parkParams(counter, 1) < acqLength
                start = 1 + round(parkParams(counter, 1) * state.acq.outputRate/1000);
                stop = 1 + round(min(acqLength, parkParams(counter, 2)) * state.acq.outputRate/1000);
                state.acq.repeatedMirrorData(start : stop, 1) = parkParams(counter, 3);
                state.acq.repeatedMirrorData(start : stop, 2) = parkParams(counter, 4);
            end
        end
    end
    
    
    