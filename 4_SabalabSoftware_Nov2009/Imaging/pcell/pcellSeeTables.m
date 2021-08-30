function pcellSeeTables(chan)
	if nargin < 1 
		chan=1;
	end
	
    global state 
	eval(['global pcellLookupTableWave' num2str(chan)])
    eval(['plot(pcellLookupTableWave' num2str(chan) ');']);
	set(gcf, 'NumberTitle', 'off');
	set(gcf, 'Name', ['Pcell ' num2str(chan) ' lookup table']);

