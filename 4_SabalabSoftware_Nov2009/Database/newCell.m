function newCell(cellType, userInitials)

global state

state.db.cell.cellType=cellType;

state.db.cell.userInitials=userInitials;
addRecordByTable('cell');
state.db.cell_id=getLastSerialInsert('cell', 'cell_id');