function b=loadobj(wv)
	disp(['Loading wave object ' inputname(1) ' ...']);
	if isstruct(wv)
		waveStruct=[];
		waveStruct=setfield(waveStruct, inputname(1), wv);
		evalin('base', ['clear '  inputname(1)]);
		loadWaveFromStructureo(waveStruct,  inputname(1));
		b=evalin('base', inputname(1));
	else
		b=wv;
	end
	