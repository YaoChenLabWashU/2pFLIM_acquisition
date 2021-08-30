function saveHeaderToTxt

    global state
    
    fid=fopen([state.files.fullFileName '_hdr.txt'], 'a');
    
    fprintf(fid, '%s', state.headerString);
    fclose(fid);