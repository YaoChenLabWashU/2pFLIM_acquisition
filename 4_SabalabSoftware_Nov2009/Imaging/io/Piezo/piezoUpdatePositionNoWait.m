function piezoUpdatePositionNoWait()

global state

% if(nargin==1)
% 	state.piezo.next_pos=varargin{1};
% end
if(state.piezo.next_pos<0)
    state.piezo.next_pos=0;
end

if isempty(state.piezo.next_pos)
	disp('*** PIEZO END MISSING.  MOVING TO ZERO ***');
	state.piezo.next_pos=0;
end

if isempty(state.piezo.last_pos)
	disp('*** PIEZO START MISSING.  ABRUPT MOVE ***');
	state.piezo.last_pos=state.piezo.next_pos;
end

vstart=state.piezo.last_pos/state.piezo.gain ;
vend=state.piezo.next_pos/state.piezo.gain ;

state.piezo.tsec=abs(state.piezo.last_pos-state.piezo.next_pos)/state.piezo.velocity ;
nsamples=round(state.piezo.tsec*10000) ; %10 kHz
vdata=linspace(vstart, vend, nsamples)' ;

if(nsamples>0)
	putdata(state.piezo.Output, vdata) ;
	start(state.piezo.Output);
end

%putsample(state.piezo.Output, vend) ;

state.piezo.last_pos=state.piezo.next_pos ;

updateGUIByGlobal('state.piezo.next_pos');