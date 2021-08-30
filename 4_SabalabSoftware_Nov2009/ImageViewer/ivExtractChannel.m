function ivExtractChannel(filename, outfile, channels)
	if nargin<3
		channels=1;
	end
	
	if nargin<1
		[fname, pname] = uigetfile({'*.tif;'}, 'Choose stack to load');
		if ~isnumeric(fname)
			filename = [pname fname];
		else
			return
		end
	end

	global state
	
	[path,name,ext] = fileparts(filename);
	cd(path);
	
	disp(['*** IN = ' filename]);
	stackHeader = readImageHeaderTif(filename);
	initialImage = opentif(filename);
	
	if nargin<2
		outfile=fullfile(path, [name '_ext' ext]);
	end
	disp(['*** OUT = ' outfile]);
	
	state.headerString=stackHeader;
	for channelCounter=1:4
		channelOn(channelCounter)= ...
			valueFromHeaderString(['state.acq.savingChannel' num2str(channelCounter)], stackHeader);
		if any(channels==channelCounter)
			eval(['state.acq.savingChannel' num2str(channelCounter) '=1;']);
		else
			eval(['state.acq.savingChannel' num2str(channelCounter) '=0;']);
		end
		updateHeader(['state.acq.savingChannel' num2str(channelCounter)]);
	end
	numberChannelsIn=length(find(channelOn));
	numberChannelsOut=length(channels);
	nSlices=size(initialImage,3)/numberChannelsIn;
	numberOfFrames=valueFromHeaderString('state.acq.numberOfFrames', stackHeader);
	if valueFromHeaderString('state.acq.averaging', stackHeader)
		numberOfFrames=1;
	end
	channelList=find(channelOn);
	
	first=1;
	for sliceCounter=1:nSlices
		for frameCounter=1:numberOfFrames % Loop through all the frames
			for channelCounter = channelList % Loop through all the channels
				startingFrame=(sliceCounter-1)*numberOfFrames*numberChannelsIn + (channelCounter-1)*numberOfFrames;
				
				if any(channels==channelCounter) % if saving
					if first % if its the first frame of first channel, then overwrite...
						imwrite(initialImage(:,:, frameCounter + startingFrame) ... % BSMOD 1/18/2
							, outfile,  'WriteMode', 'overwrite', 'Compression', 'none', 'Description', state.headerString);
						first = 0;
					else
						imwrite(initialImage(:,:, frameCounter + startingFrame) ... % BSMOD 1/18/2
							, outfile,  'WriteMode', 'append', 'Compression', 'none');
					end	
				end
			end
		end
	end
	
	
function updateHeader(globalName)
	global state
    val=eval(globalName);
    if ~isnumeric(val) & ~ischar(val)
        val
        disp(['updateHeaderString: unknown type for ' globalName]);
        val='0';
        subUpdateHeader(globalName, val);
    elseif isnumeric(val)
        if length(val)~=1
            for index=1:length(val)
                [row col] = ind2sub(size(val),index);
                subGlobalName = [globalName '(' join(num2str([row;col]),', ') ')'];
                subUpdateHeader(subGlobalName, num2str(val(index)));
            end
        else
            val=num2str(val);
            subUpdateHeader(globalName, val);
        end
    else
        val=['''' val ''''];
        subUpdateHeader(globalName, val);
    end
    
function subUpdateHeader(globalName, val)
    global state
    
    pos=findstr(state.headerString, [globalName '=']);
    if length(pos)==0
        state.headerString=[state.headerString globalName '=' val 13];
    else
        cr=findstr(state.headerString, 13);
        index=find(cr>pos);
        next=cr(index(1));
        if length(next)==0
            state.headerString=[state.headerString(1:pos-1) globalName '=' val 13];
        else
            state.headerString=[state.headerString(1:pos-1) globalName '=' val state.headerString(next:end)];
        end
    end