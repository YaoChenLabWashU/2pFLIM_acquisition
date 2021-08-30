function exportAllToIgor(prefix, template, clearFromMemory, avgMode, forceLoadFromDisk, sizeLimit)
% exportAllToIgor(prefix, template, clearFromMemory, avgMode, forceDisk, sizeLimit)
%
% This function takes all the MATLAB WAVES in a folder and exports them
% into Igor Pro WAVE TEXT FILE format.
%
% All arguments are optional and defined as follows
%	prefix		a string plus an '_' that is added to the begining of the name of each
%				wave.  For example if prefix is 'bs1' then a wave named
%				'AD_34' will be saved as 'bs1_AD_34'.  The DEFAULT is ''
%	template	a wildcard string used for selecting files from folder for
%				export.  Use '' or '*' for all files.  Use '*avg' for all files
%				ending in 'avg'.  Use '*avg*' for all files with avg
%				anywhere in the filename.  A '.mat' extension is automatically 
%				added.  The DEFAULT is '*'.  
%	clearFromMemory		The DEFAULT is 1.
%				0	leave the waves in memory.  Note that memory may fill
%					up if many waves are loaded from disk
%				1	clear waves from memory after exporting.
%					WARNING -- This will erase waves that may already have
%					been in memory !!  
%	avgMode		specifies how waves that are AVERAGES of other waves are
%				handled.  All averages are turned into Bernardo's Igor Pro
%				average format and should be fully functional with him
%				averageUtilities in Igor.  The DEFAULT is 1.
%				The modes are:
%				0 	save the average and each of its components in
%					separate files.  The user is ther responsible for
%					loading all the files into Igor
%				1	save the average and all of its components in a single
%					file.  Loading this one file into Igor will make a
%					fully functional average.  
%				2	options 1 and 2 together.  That is the average is save
%					with its components and the components are also saved
%					independently.  
%	forceLoadFromDisk	The DEFAULT is 1.
%				0 	if a wave is found in memory export that one without
%					loading it from disk.  This is dangerous and should be
%					used only with clearFromMemory=0 when the experiment is
%					fully loaded in memory
%				1	force all waves to be loaded from the disk even if they
%					are already found in memory.  
%				-1	Don't go to disk at all.  Use only the waves that are
%					in memory
%	sizeLimit	(in Kb) Only files smaller than this limit are loaded.  The
%				DEFAUL is 1000.  
%
    tic
        if nargin<6
            sizeLimit=1000;		% don't try to retreive and export any "waves" greater than 1000 Kb
        end
        if nargin<5
            forceLoadFromDisk=1;
        end
        if nargin<4
            avgMode=1;
        end
        if nargin<3
            clearFromMemory=1;
        end
        if nargin<2
            template='*';
        end
        if nargin<1
            prefix='';
        end

        if isempty(template)
            template='*';
        end

        if forceLoadFromDisk>=0
            [fname, pname] = uiputfile('path.mat', 'Choose data path...');
            if isnumeric(pname)
                return
            end
            cd(pname);
        end

        [fname, pnameOut] = uiputfile('path.itx', 'Choose an output path...');
        if isnumeric(pnameOut)
            return
        end

        if isempty(prefix)
            filePrefix='';
        else
            filePrefix=[prefix '_'];
        end

        if forceLoadFromDisk>=0
            disp('Reading disk directory...');
            files=dir(fullfile(pname, [template '.mat']));
        else
            disp('Searching for waves in memory...');
            files=evalin('base', ['whos(''' template ''');']);
            for counter=1:length(files)
                if strcmp(files(counter).class, 'wave')	% its a wave
                    files(counter).isdir=0;
                else
                    files(counter).isdir=1;
                end
            end
        end

        notDone=zeros(1, length(files));
        doneFiles={};



        disp('Exporting averages...');
        for counter=1:length(files)	%loop through the filelist
            if ~files(counter).isdir	% made sure its a file and not a directory
                [path, fname, fext]=fileparts(files(counter).name);
                if files(counter).bytes>sizeLimit*1000
                    disp(['*** ' fname ' is beyond the size limit.  If you really want this file, adjust the limit ***']);
                elseif ~any(strcmp(fname, doneFiles))	% was it exported already?
                    disp('');
                    if forceLoadFromDisk>=0
                        retreiveWave(fname, path, forceLoadFromDisk);
                    end
                    if ~iswave(fname)
                        disp(['*** exportAllToIgor: Error loading ' fname ' from ' files(counter).name ' ***']);
                    else
                        comps=avgComponentList(fname);
                        if isempty(comps)
                            notDone(counter)=1;
                        else
                            for counter=1:length(comps)
                                if forceLoadFromDisk>=0
                                    retreiveWave(comps{counter}, path, forceLoadFromDisk);
                                end
                            end
                            if (avgMode==1) || (avgMode==2)		% put averages and components in one file
                                exportAvg(fname, prefix, fullfile(pnameOut, [filePrefix fname]));
                                if avgMode==1
                                    doneFiles=[doneFiles {fname} comps];	% save the components only with the avg
                                else
                                    doneFiles=[doneFiles {fname}];	% let the components get saved independently too
                                end
                            elseif avgMode==0			% put average and components in separate files
                                for name=[{fname} comps];
                                    exportWave(fname, prefix, fullfile(pnameOut, [filePrefix name{1}]));
                                end
                                doneFiles=[doneFiles {fname} comps];
                            end
                            if clearFromMemory 
                                evalin('base', ['clear ' fname]);
                                if (avgMode==0) || (avgMode==1)
                                    for clearName=comps
                                        evalin('base', ['clear ' clearName{1}]);
                                    end
                                end
                            end

                        end
                    end
                end
            end
        end

        disp('Exporting other waves...');
        for counter=find(notDone)
            [path, fname, fext]=fileparts(files(counter).name);
            if ~any(strcmp(fname, doneFiles))	% was it exported already?
                if iswave(fname)
                    exportWave(fname, prefix, fullfile(pnameOut, [filePrefix fname]));
                    if clearFromMemory 
                        evalin('base', ['clear ' fname]);
                    end
                end	
            end	
        end

        disp('Export Finished');
    toc
