function spc_openCurves(fname, page)
global spc gui FLIMchannels
    
if nargin < 2
    page = 1;
end

no_switches = 0;
try
    save_switchess = spc.switchess;
catch
    no_switches = 1;
end

no_fits = 0;
try
    save_fits = spc.fits;
catch
    no_fits = 1;
end
% TODO? roiP = get(gui.spc.figure.mapRoi, 'position');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp (['Reading ', fname]);
if findstr(fname, '.sdt')
    spc_readdata(fname);
elseif findstr(fname, '.mat')
    % GY - using this save type
    % need to restore selectively
    cc = load (fname);
    if isfield(cc,'spc')
        spn='spc';
    elseif isfield(cc,'spcSave')
        spn='spcSave';
    end
    if isfield(cc.(spn),'imageMods')
        spc.imageMods= cc.(spn).imageMods;
    else
        spc.imageMod = cc.(spn).imageMod;
        for fc=FLIMchannels
            spc.imageMods{fc}=spc.imageMod/(fc*3);
        end
    end
    
    spc.originalFile = cc.(spn).filename;
    spc.datainfo = cc.(spn).datainfo;
    try 
        spc.SPCdata = cc.(spn).SPCdata;
    catch  % a few days with incorrect storage
        spc.SPCdata = cc.(spn).datainfo;
        spc.datainfo.psPerUnit=195.4292;
        spc.datainfo.pulseInt=spc.datainfo.psPerUnit*64/1000;
    end
    
    if isfield(spc.datainfo,'numberOfZSlices')
        spc_setupSliceChooser;
    end
    if isfield(cc.(spn),'imageModSlices') && ...
            spc.datainfo.numberOfZSlices>1
        spc.imageModSlices=cc.(spn).imageModSlices;
        % now make the Sum of all calculation
        for fc=FLIMchannels
            spc.imageMods{fc}=spc.imageModSlices{fc,1};
            for slice=2:spc.datainfo.numberOfZSlices
                size(spc.imageMods{fc})
                size(spc.imageModSlices{fc,slice})
                spc.imageMods{fc}=spc.imageMods{fc}+spc.imageModSlices{fc,slice};
            end
            % and save the existing max projections
            %    these are calculated when acquired, and divided by 
            %    number of frames
            spc.maxProjects{fc}=cc.(spn).projects{fc};
            % (regular 'projects' are recalc'ed in spc_redrawSetting)
        end
        
    else
        spc.imageModSlices={};
        for fc=FLIMchannels; spc.maxProjects{fc}=[]; end
    end

    
    if isfield(cc.(spn),'lifetimes')
        spc.lifetimes = cc.(spn).lifetimes;  % shouldn't need these - check out gy
    else
        spc.lifetime = cc.(spn).lifetime;  % shouldn't need these - check out gy
        for fc=FLIMchannels
            spc.lifetimes{fc}=spc.lifetime/(fc*3);
        end
    end
    spc.size = cc.(spn).size;
    spc.filename=fname;
    spc_updateGUIbyGlobal('spc.filename');
    
    % gy for multiFLIM (but realize that might be overridden below)
    if isfield(cc.(spn),'fits')
        spc.fits=cc.(spn).fits;
        for fc=FLIMchannels
            spc_FillGUIfromGlobals(fc)
        end
    else
        for fc=FLIMchannels
            spc_translateFitToFits(fc);
            spc_FillGUIfromGlobals(fc);
        end
    end
    
    
     
    % end temporary fix
    
    if findstr(fname, 'FLIM')
        pos = findstr(fname, 'FLIM');
        pos = pos(end);  % last occurrence, if multiple FLIM's
        [pathstr namestr] = fileparts(fname(1:pos-1));
        gui.gy.filename.path = [pathstr filesep];
        gui.gy.filename.base = namestr;
        try 
            gui.gy.filename.num = str2double(fname(pos+4:pos+7));
            set(gui.spc.spc_main.File_N,'String',num2str(gui.gy.filename.num));
        end
    end
elseif findstr(fname, '.tif')
    spc_loadTiff (fname, page);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~no_switches
    spc.switchess = save_switchess;
    spc_FillGUIfromGlobals(spc_mainChannelChoice);
end
% when reading in the file, do NOT update fits, unless there were none
% before
if ~no_fits
    spc.fits = save_fits;
    spc_FillGUIfromGlobals(spc_mainChannelChoice);
end


% TODO? set(gui.spc.figure.mapRoi, 'position', roiP);

% if roiP(3)<=1 | roiP(4) <= 1
%     spc_selectAll;
% end

spc_redrawSetting(1);



