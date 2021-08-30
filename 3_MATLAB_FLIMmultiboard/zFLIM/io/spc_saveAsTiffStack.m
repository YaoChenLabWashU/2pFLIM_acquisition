function spc_saveAsTiffStack (fileName, append, newHeader)
% save nPhotons and Lifetime map stacks (varying z,fc,N/L)
global spc FLIMchannels
%%%%newHeader = 2::: Making header quickly.
if nargin < 3
    newHeader = 1;
end
if nargin<2
    append = 0;
end

% give the user a chance to change the save name
[fname path]=uiputfile('*.tif','Save TIFF stack as...',fileName);
fname=[path fname];

if ~append
    disp([datestr(clock), ' Saving SPC file = ', fname]);
end

% gy multiFLIM 20111201
% saves the projection and lifetime maps
nZ=spc.datainfo.numberOfZSlices;
fcs=numel(FLIMchannels); 
szX=spc.SPCdata.scan_size_x; szY=spc.SPCdata.scan_size_y;
TIFFsize=[nZ,fcs,2];
TIFFpage=[szX, szY];
headerstr=[spc.filename ' ;  TIFFsize=   ' mat2str(TIFFsize) ...
    '; TIFFpage=   ' mat2str(TIFFpage) '; ' spc_makeheaderstr];
% first write the number of photons
first=1;
for fc=FLIMchannels
    for z=1:nZ
        % calculate the projection (total # photons) for this slice
        infostr=['z=' num2str(z) '/' num2str(nZ) ...
            '; fc=' num2str(fc) '/' num2str(fcs) '; data=Nphotons; '];
        if nZ==1
            imTemp=uint16(reshape(sum(spc.imageMods{fc}, 1), szX, szY));
        else
            imTemp=uint16(reshape(sum(spc.imageModSlices{fc,z}, 1), szX, szY));
        end
        if first
            imwrite(imTemp,fname,'WriteMode', 'overwrite', ...
                'Compression', 'none', 'Description', [infostr headerstr]);
            first=0;
        else
            imwrite(imTemp,fname,'WriteMode', 'append', ...
                'Compression', 'none', 'Description', infostr);
        end
    end
end
for fc=FLIMchannels
    for z=1:nZ
        % calculate the lifetime map for this slice
        infostr=['z=' num2str(z) '/' num2str(nZ) ...
            '; fc=' num2str(fc) '/' num2str(fcs) '; data=Lifetime*100; '];
        if nZ==1
            imTemp=uint16(100*spc.lifetimeMaps{fc});
        else
            spc.imageMods{fc}=spc.imageModSlices{fc,z};
            spc_calcLifetimeMap(fc);
            imTemp=uint16(100*spc.lifetimeMaps{fc});
        end
        imwrite(imTemp,fname,'WriteMode', 'append', ...
            'Compression', 'none', 'Description', infostr);
    end
end

% clean up if we swapped out data
if nZ>1
    for fc=FLIMchannels
        spc.imageMods{fc}=spc.imageModSlices{fc,z};
        spc_calcLifetimeMap(fc);
    end
end