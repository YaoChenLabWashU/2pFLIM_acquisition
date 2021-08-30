function ivBatchInterp

	[fname, pname] = uiputfile({'*.tif'}, 'Choose folder to process', 'dummy.tif');
	mkdir(pname, 'interp');
	filterpath=strcat(pname, 'interp');
	filterpath=strcat(filterpath, '\');
	d=dir (pname);
	h = waitbar(0,'Batch process Tiff stack...', 'Name', 'Process Tiff stack', 'Pointer', 'watch');
	images=size(d, 1);
	for i=1:images
        if d(i).isdir == 0
            [path,name,ext] = fileparts(d(i).name);
            if strcmp(lower(ext), '.tif') == 1
                if isempty(strfind(name, 'max'))
                    filename=d(i).name;
     			    outfile=fullfile(filterpath, [name '_int' ext]);          	
				    waitbar(i/images, h, ['Process Image No: ' filename]);
			    	ivInterpImage(fullfile(pname, filename), outfile); 
                end
            end
        end
	end
	waitbar(1, h, 'Done');
	close(h);
	
	
	
	
	
