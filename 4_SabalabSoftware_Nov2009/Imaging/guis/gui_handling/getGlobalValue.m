function out=getGlobalValue(glo)
	try
		out=evalin('base', glo);
	catch
		out=[];
	end