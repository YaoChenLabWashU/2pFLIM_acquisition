function lastserial=getLastSerialInsert(table, field)

global state

lastserial=0;

try
if(state.db.conn==0)
	disp(['Not connected to database'])
	return
end
catch
	disp(['Not connected to database'])
	return	
end

seq_name=[table '_' field '_seq'];

sql=['SELECT currval(''' seq_name ''')'];

res1 = pqexec(state.db.conn, sql);

if res1==0 
    error('Exec failed');
end;

%oid=PQoidStatus(res1);
try
lastserial=pqgetvalue(res1,0,0);% for now.
catch
    disp(['getLastSerialInsert: no serial retrieved'])
end
pqresulterrormessage (res1);
pqclear(res1);

