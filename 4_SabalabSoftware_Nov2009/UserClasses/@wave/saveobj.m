function b=saveobj(wv)
    
    global state
    
    b=wv;
	disp(['Saving wave object ' inputname(1) ' ...']);
	
    
    
%    try
%    if(state.db.conn~=0)
%            state.db.oid=storeWaveDB(wv);
%    end
%catch
%    disp(['Error in saving wave to database : ' lasterr]);
%end