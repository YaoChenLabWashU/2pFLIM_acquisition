function TNSetPath

    global state
    
    basedir='C:\tom\data\';
    cd(basedir);
    
    today=[datestr(now, 'dd') datestr(now, 'mmm') datestr(now, 'yy')];
    
    notFoundDir=1;
    incChar='a';
    
    while(notFoundDir)
       dirname=[basedir today char(incChar)];
       try
           cd(dirname);
           incChar=incChar+1; %this will only happen if cd wass successful
       catch
           notFoundDir=0;
       end 
    end
    
    state.files.savePath=[dirname '\'];
     state.files.baseName=[today char(incChar)];
    
    evalin('base', ['!mkdir ' state.files.savePath]);
    
    state.files.savePath=[dirname '\'];
	updateFullFileName(0);
	cd(state.files.savePath);
    
    state.files.baseName=[today char(incChar)];
    updateGUIByGlobal('state.files.baseName');
    
    disp(['*** SAVE PATH = ' state.files.savePath ' ***']);
    disp(['*** BASE NAME = ' state.files.baseName ' ***']);