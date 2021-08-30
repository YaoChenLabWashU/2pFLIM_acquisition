function serial=storeWaveDB(wv)

global state;

try
if(state.db.conn==0)
	disp(['Not connected to database'])
	return
end
catch
	disp(['Not connected to database'])
	return	
end

sql=['INSERT INTO waves values (''' wv.UserData.name ''',''{' wvData2String(wv)];

myst=wvData2String(wv);

sql=sql(1:end-1);

sql=[sql '}'',' num2str(wv.xscale(1)) ','  num2str(wv.xscale(2)) ')'];

res1 = pqexec(state.db.conn, sql);

if res1==0 
    error('Exec failed');
end;

%oid=PQoidStatus(res1);

pqresulterrormessage (res1);
pqclear(res1);

serial=getLastSerialInsert('waves', 'wave_id');