function ivMakeMovie(objects)
	if nargin<1
		objects=0;
	end
	global state 
	for counter=1:state.imageViewer.tsNumberOfFiles
		ivFlipTimeSeries(counter);
		if (objects)
			ivHighlightObject;
		end
		drawnow; 
        ivBringSelectionToFront;
        if counter==1
            state.imageViewer.movie=getframe;
        else
            state.imageViewer.movie(counter)=getframe;
        end
    end
    [fname, pname]=uiputfile('*.avi', 'Select movie file');
    if isnumeric(fname) 
        return
    end
    movie2avi(state.imageViewer.movie, fullfile(pname, fname), 'Compression', 'CinePak', 'FPS', 6);