function reviewFluorData(acqNumber, channelList)
    
    global state
    
    if nargin<1
        acqNumber=state.files.reviewCounter;
    end
    
    try
        if nargin<2
            channelList=1:state.init.maximumNumberOfInputChannels;
        end
    catch
        return
    end
    
    found=0;
    
    err=0;
    for channelCounter=channelList
        done=0;
        roiCounter=1;
        while ~done
            try
                scanName=ROIScanName(channelCounter, roiCounter, acqNumber);
                foundFile=retreive(scanName, state.files.savePath);
                
                if foundFile
                    if evalin('base', ['iswave(' scanName ')'])
                        duplicateo(scanName, ROIScanName(channelCounter, roiCounter));
                        found=1;
                    elseif evalin('base', ['isstruct(' scanName ')'])
                        waveStruct=[];
                        waveStruct=setfield(waveStruct, scanName, evalin('base', scanName));
                        evalin('base', ['clear ' scanName]);
                        loadWaveFromStructureo(waveStruct, scanName);
                        duplicateo(scanName, ROIScanName(channelCounter, roiCounter));
                        found=1;
                    else
                        disp('*** reviewFluorData : found file but does not contain wave or readable struct ***');
                    end
                else
                    done=1;
                    waveo(ROIScanName(channelCounter, roiCounter), []);
                end
                
                roiCounter=roiCounter+1;
            catch
                err=1;
            end
        end
    end
    
    if ~found & ~err
        if ~isempty(state.files.savePath)
            disp(['*** reviewFluorData: No fluorescence data for acquisition #' num2str(acqNumber) ' found in ' state.files.savePath]);
        end			
    end

