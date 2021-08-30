function loadFiguresFromPath(path)
	if nargin<1
		global state
		path=state.figurePath;
	end

	files=dir(fullfile(path, '*.fig'));
	for counter=1:length(files)
		files(counter).name
		path
		open(fullfile(path, files(counter).name));
		drawnow
		reactivateWavePlot;
        figure(gcf);
	end
	disp(['*** Loaded Figures from ' path '***']);