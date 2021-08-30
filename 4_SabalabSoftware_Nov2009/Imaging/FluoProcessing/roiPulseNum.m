function out=roiPulseNum
	out=0;
	try
		global state
		out=state.cycle.lastPulseUsed0;
	catch
	end