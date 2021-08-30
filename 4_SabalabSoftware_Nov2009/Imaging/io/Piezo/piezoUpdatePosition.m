function piezoUpdatePosition()

global state

piezoUpdatePositionNoWait();

%wait(state.piezo.Output, state.piezo.tsec+1) ;
piezoWait