function spc_calculateROIvals(verbose)
% calculates values for the 'gyROIs' (which are the same position in all figs)
global spc gui imageData FLIMchannels

gui.gy.ROIvals=[];
if isfield(gui.gy,'rois')
    nROI=numel(gui.gy.rois);
else
    return;
end

% if this is during an acquisition, do a rough background calc on 2 channels
if iscell(imageData)
    gui.gy.bkgG=min(min(imageData{1}));
    gui.gy.bkgR=min(min(imageData{2}));
end
for nr=1:nROI
    mask=gui.gy.rois{nr}.mask;
    
    
    
    
    for fc=FLIMchannels
        t_Offset=spc.switchess{fc}.figOffset;% get the figure offset from the GUI
        % if acquiring, calculate the background values as minimum value in each image
        [~,range]=spc_fitParamsFromGlobal(fc);
        % Counts:
        try  % Projection from spc (mean)
            val=calcVal(spc.projects{fc},mask,0);
            
            gui.gy.ROImean(nr,fc)=val;
%             Our code to account for >6 ROIs
            if ~isfield(gui.spc.projects{fc}, ['countROI' num2str(nr)])
                gui.spc.projects{fc}.(['countROI' num2str(nr)]) = ...
                    uicontrol('Style','text','ForegroundColor','y','Unit','normalized','Position',[.01,.85-(nr-1)*0.07,.1,.05]);
            end
            set(gui.spc.projects{fc}.(['countROI' num2str(nr)]),'String',num2str(val,3));
            set(gui.spc.projects{fc}.(['countROI' num2str(nr)]),'BackgroundColor','k');
        catch
            gui.gy.ROImean(nr,fc)=NaN;
        end
        try  % Projection from spc (total counts)
            gui.gy.ROIcount(nr,fc)=sum(sum(spc.projects{fc}.*mask));
        catch
            gui.gy.ROIcount(nr,fc)=NaN;
        end
        
        
        % LifetimeMap (empirical mean lifetime calculation)
        % get the mask for this ROI
        try 
            % gy 201112 changed to use current projectN and lifetimeMap
            nTimesTau=mask .* spc.projects{fc} .* spc.lifetimeMaps{fc};
            val=sum(nTimesTau(:)) / sum(spc.projects{fc}(:) .* mask(:));
%             fullmask=repmat(permute(mask,[3 1 2]),[size(spc.imageMods{fc},1) 1 1]);
%             % now sum over all of the included pixels
%             maskedLife=sum(sum(fullmask.*spc.imageMods{fc},2),3);  % # photons as function of t (bin)
%             % now restrict to the fitting range (as chosen in spc_main)
%             maskedLife=maskedLife(range(1):range(2));
%             tt=1:length(maskedLife); % make a vector of the time values (bin numbers)
%             % calculate the [integral of (binNo*Nphotons)] divided by
%             % totalNphotons and scaled by the time per bin, then subtract tOffset
%             val=(sum(maskedLife.*tt(:))/sum(maskedLife))*spc.datainfo.psPerUnit/1000-t_Offset;
        catch
            val=NaN;
        end
        gui.gy.ROIlife(nr,fc)=val;
                  % Our code to account for >6 ROIs
        if ~isfield(gui.spc.lifetimeMaps{fc}, ['lifeROI' num2str(nr)])
            gui.spc.lifetimeMaps{fc}.(['lifeROI' num2str(nr)]) = ...
                uicontrol('Style','text','ForegroundColor','y','Unit','normalized','Position',[.01,.85-(nr-1)*0.07,.1,.05]);
        end
        set(gui.spc.lifetimeMaps{fc}.(['lifeROI' num2str(nr)]),'String',num2str(val,3));
        set(gui.spc.lifetimeMaps{fc}.(['lifeROI' num2str(nr)]),'BackgroundColor','k');
    end  % fc=FLIMchannels
    % now calculate values for the same ROIs in standard PMT channels 1 & 2
    if iscell(imageData)
        try  % Green
            gui.gy.ROIvals(nr,1)=calcVal(imageData{1},mask,gui.gy.bkgG);
        catch
            try
                gui.gy.ROIvals(nr,1)=calcVal(gui.gy.imgG,mask,gui.gy.bkgG);
            catch
                gui.gy.ROIvals(nr,1)=NaN;
            end
        end
        try  % Red
            gui.gy.ROIvals(nr,2)=calcVal(imageData{2},mask,gui.gy.bkgR);
        catch
            try
                gui.gy.ROIvals(nr,2)=calcVal(gui.gy.imgR,mask,gui.gy.bkgR);
            catch
                gui.gy.ROIvals(nr,2)=NaN;
            end
        end
    end % if iscell(imageData)
    
    
end % nr=1:nROI

% blank out the unused value boxes

if isfield(gui.gy,'rois') && length(gui.gy.rois)<6
    for k=(length(gui.gy.rois)+1):6
        for fc=FLIMchannels
            bkColor = get(gui.spc.projects{fc}.figure,'Color');
            set(gui.spc.projects{fc}.(['countROI' num2str(k,1)]),'String','');
            set(gui.spc.projects{fc}.(['countROI' num2str(k,1)]),'BackgroundColor',bkColor);
            set(gui.spc.lifetimeMaps{fc}.(['lifeROI' num2str(k,1)]),'String','');
            set(gui.spc.lifetimeMaps{fc}.(['lifeROI' num2str(k,1)]),'BackgroundColor',bkColor);
        end
    end
end

return


%%%%%%%%%%%% OLD CODE FOLLOWS







% blank out the string and background on unused ROI's

if verbose
    disp('Green        Red       spc_N     tau-mean  Photons');
    disp(num2str(gui.gy.ROIvals,'%12.2f'));
end

% gui.gy.ROIvalsAll{gui.gy.filename.num}=gui.gy.ROIvals;




function val_SPCcalc=calcVal(img,mask,bkg)
val_SPCcalc=sum(sum((img-bkg).*mask))/sum(sum(mask));