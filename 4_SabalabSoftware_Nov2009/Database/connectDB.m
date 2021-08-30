function connectDB

global state;

% 'host = localhost dbname=labdata user=postgres password=ntcfop99';
conninfo='';

if(isfield(state.db, 'host'))
    conninfo=[conninfo 'host=' state.db.host ' '];
end

if(isfield(state.db, 'dbname'))
    conninfo=[conninfo 'dbname=' state.db.dbname ' '];
end

if(isfield(state.db, 'user'))
    conninfo=[conninfo 'user=' state.db.user ' '];
end

if(isfield(state.db, 'password'))
    conninfo=[conninfo 'password=' state.db.password ' '];
end

state.db.conn = pqconnectdb(conninfo);
if state.db.conn==0 
    error('Could not establish connection');
end;

disp (['Database: ' pqdb(state.db.conn)])
disp (['User: ' pquser(state.db.conn)])
disp (['Status: ' num2str(pqstatus(state.db.conn))])

