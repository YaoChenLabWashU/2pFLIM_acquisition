function out=defaultAxisScaleMode

	out=waveUserDefaults('axisAutoScale');	% BSMOD below
	if isempty(out)
		out=1;
	end
