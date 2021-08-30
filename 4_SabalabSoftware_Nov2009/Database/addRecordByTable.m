function addRecordByTable(table)

global state

try
if(state.db.conn==0)
	disp(['Not connected to database'])
	return
end
catch
	disp(['Not connected to database'])
	return	
end

ind=strcmpi(state.db.observation(:,2), table);

myGlobals=state.db.observation(ind,1);
myFields=state.db.observation(ind,3);

nFields=size(myFields,1);

if(nFields<1)
    return
end

%syntax: INSERT INTO users (name, age, gender) value('Tom', '28', 'M')
sql =['INSERT INTO ' table '('];

for i=1:nFields
	sql=[sql char(myFields(i)) ', '];
end

sql=[sql(1:end-2) ') values ('];

for i=1:nFields
	eval(['val=' char(myGlobals(i)) ';']);
	sql=[sql '''' num2str(val) ''', '];
end

sql=[sql(1:end-2) ')'];

res1 = pqexec(state.db.conn, sql);

if res1==0 
    disp(['addRecordByTable failed']);
end;

oid=PQoidStatus(res1);

pqresulterrormessage (res1);
pqclear(res1);