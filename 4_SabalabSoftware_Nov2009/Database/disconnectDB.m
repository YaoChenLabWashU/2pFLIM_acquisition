function disconnectDB

global state;

pqfinish(state.db.conn);
