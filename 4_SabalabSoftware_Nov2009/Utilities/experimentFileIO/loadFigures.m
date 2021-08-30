function loadFigures(filename, pathname)

	if nargin==1 & iscell(filename) 	% they're giving the figure list and we'll assume that all paths are set
		global savedFigureList
		evalin('base', 'global savedFigureList');
		savedFigureList=filename;
	elseif nargin==0 | nargin==2
		if nargin==0
			[filename, pathname] = uigetfile('*_savedFigureList.mat', 'Select figure list load...');
		end
		if isempty(filename) | isnumeric(filename)
			disp('loadFigures : cancelled');
			return
		end
		global savedFigureList
		evalin('base', 'global savedFigureList');

		evalin('base', ['load(''' fullfile(pathname, filename) ''');']);
	end

	cd(pathname);
	for counter=1:length(savedFigureList)
		name=savedFigureList{counter};
		disp(['Loading figure ' name '...']);
		try
			open([name '.fig']);
		catch
			disp(['Error loading figure : ' lasterr]);
		end
	end
	fListOff=findobj('Type', 'figure', 'Visible', 'off');
	fList=findobj('Type', 'figure');
	for counter=1:length(fList)
		try
			figure(fList(counter));
			reactivateWavePlot;
		catch
			disp(['Error reactivating figure : ' lasterr]);
		end
	end
	set(fListOff, 'Visible', 'off')
