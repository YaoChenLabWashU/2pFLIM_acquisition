function wname=getWaveDB(oid)

global state;

sql= ['SELECT * FROM waves WHERE OID=' num2str(oid)];

res1 = pqexec(state.db.conn, sql);

if res1==0 
    error('Exec failed');
end;

pqresulterrormessage (res1);

nwaves = pqntuples(res1) ;

if nwaves~=1
    wname = '';
    disp(['getwaveDB: found ' num2str(nwaves) ' waves'])
else
    wname=pqgetvalue(res1,0,0);
    data=pqgetvalue(res1,0,1);
    waveo(wname, data);
    str=[wname '.xscale=[' num2str(pqgetvalue(res1,0,2)) ' ' num2str(pqgetvalue(res1,0,3)) '];'];
    evalin('base', str);
end

pqclear(res1);
