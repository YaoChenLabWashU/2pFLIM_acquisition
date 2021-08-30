function addDBObservation(globalName, tableandfield)

global state

try
	last=size(state.db.observation, 1);
catch
	last=0;
end
last=last+1;

[table,tableandfield]=strtok(tableandfield, ':');
field=tableandfield(2:end);

if(size(table,2)<1)
	disp(['Error setting DBobservation'])
	return
end

if(size(field,2)<1)
	disp(['Error setting DBobservation'])
	return
end

state.db.observation{last,1}=globalName;
state.db.observation{last,2}=table;
state.db.observation{last,3}=field;