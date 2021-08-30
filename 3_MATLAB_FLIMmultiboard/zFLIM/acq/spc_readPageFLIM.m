function spc_readPageFLIM
% read the image/lifetime from the SPC device 
%   and calculate spc.imageMod, spc.project, spc.lifetime
% gy multiboard modified 201202


% GY: read in a full "page".  This code extracted from FLIM_imageAcq
% for simplicity, right now this supports only a single "page" and no
% averaging

global state spc

%stop(state.spc.acq.mtSingle);
for m=state.spc.acq.modulesInUse
    FLIM_StopMeasurement(m);
end

% read in a page for each active module and parse it out to the appropriate
% channels (gy multiboard 201202)
for m=state.spc.acq.modulesInUse
    % calculate sizes (gy 201204 dualLaserMode: I think these should be robust)
    blocks_per_frame = state.spc.acq.SPCMemConfig{m+1}.blocks_per_frame;
    frames_per_page = state.spc.acq.SPCMemConfig{m+1}.frames_per_page;  % this should be how multiple channels are stored
    block_length = state.spc.acq.SPCMemConfig{m+1}.block_length;
    % allocate an array
    image1 = [];
    memorysize =  block_length* blocks_per_frame*  frames_per_page;
    image1(memorysize)=0.0;
    % read in page zero (takes ~ 64 ms;  gy 201101)
    [errCode image1]=calllib('spcm32','SPC_read_data_page',m, 0, 0, image1);
    %GY201101  state.spc.internal.image_all = image1;
    % give a warning if page has only zeros
    if sum(image1(:)) == 0
        disp(['*** FLIM WARNING: Data is all zeros [module ' num2str(m+1) ']']);
    end
    spc.errCode  = errCode;
    
    scan_size_x = state.spc.acq.SPCdata{m+1}.scan_size_x;
    scan_rout_x = state.spc.acq.SPCdata{m+1}.scan_rout_x;
    res = 2^state.spc.acq.SPCdata{m+1}.adc_resolution;
    % special handling for the number of lines
    % gy modified for dualLaserMode 201204 
    % re-enabled 20120815... should work now because eliminated the
    %     SPC_enable_sequencer call per suggestion of B&H
    if state.acq.dualLaserMode==1
        scan_size_y = state.spc.acq.SPCdata{m+1}.scan_size_y;
    elseif state.acq.dualLaserMode==2 % acquiring twice the number of lines
        scan_size_y = state.spc.acq.SPCdata{m+1}.scan_size_y/2;
    end
    
    % multiboard - figure out the channels
    framesChans = state.spc.acq.modChans{m+1};
    
    imageSize=memorysize/frames_per_page;
    
    for jj=1:size(framesChans,1)
        frame=framesChans(jj,1); % first column is the frame
        chan=framesChans(jj,2);  % second column is the channel number
        if frame>frames_per_page || frame>scan_rout_x
            disp('Not all requested FLIM channels were acquired:');
            disp([' board ' num2str(m+1) ' frame ' num2str(frame) ' chan ' num2str(chan)]);
            disp(' ADJUST scan_rout_x in FLIM Parameters');
        else
            % if bitget(state.spc.FLIMchoices(fc),2) % if we need this specific channel
            iEnd=frame*imageSize;        % calculate the end and start of the frame
            iStart=iEnd+1-imageSize;
            % gy modified for dualLaserMode 201204
            % re-enabled 20120815... should work now because eliminated the
            %     SPC_enable_sequencer call per suggestion of B&H
            if state.acq.dualLaserMode==1
                % reshape the portion of the image corresponding to this channel
                imageF = (reshape(image1(iStart:iEnd), res, scan_size_x, scan_size_y));
                imageF = double(permute(imageF, [1,3,2]));
            elseif state.acq.dualLaserMode==2  % need to alternate lines.  for now, discard the even lines
                imageF = (reshape(image1(iStart:iEnd), res, scan_size_x, 2*scan_size_y));
                imageF(:,:,2*(1:scan_size_y))=[]; % DELETE THE EVEN LINES
                imageF = double(permute(imageF, [1,3,2]));
            end
            
            if state.acq.numberOfZSlices>1
                % if there's more than one slice, keep an array of them
                % the zSliceCounter starts at 0
                spc.imageModSlices{chan,state.internal.zSliceCounter+1}=imageF;
                if state.internal.zSliceCounter==0
                    spc.imageMods{chan}=imageF;
                    spc.projects{chan}=reshape(sum(spc.imageMods{chan}, 1), scan_size_y, scan_size_x);
                else
                    % make regular old spc.imageMods{chan} contain the sum over all slices
                    spc.imageMods{chan}=spc.imageMods{chan}+imageF;
                    % and the projection will be the max(projection),
                    project=reshape(sum(spc.imageMods{chan}, 1), scan_size_y, scan_size_x);
                    spc.projects{chan}=max(spc.projects{chan},project);
                end
            else
                spc.imageMods{chan}=imageF;
                spc.imageModSlices={};
                spc.projects{chan}  = reshape(sum(spc.imageMods{chan}, 1), scan_size_y, scan_size_x);
            end
            
            % calculate the total number of photons in each pixel
            % (across all zSlices if slicing)
            spc.lifetimes{chan} = sum(sum(spc.imageMods{chan}, 2),3);
            % end
        end % if frame>frames_per_page
    end % over frames
end % over modules