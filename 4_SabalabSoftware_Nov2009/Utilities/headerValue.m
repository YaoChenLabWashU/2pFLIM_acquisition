function out=headerValue(header, varName, convert)
	if nargin<3
		convert=0;
	end
	pos=findstr(header, [varName '=']);
	if isempty(pos)
		out=[];
	else
		posEq=findstr(header(pos:end), '=');
		posRt=findstr(header(pos:end), 13);;
		if isempty(posRt)
			out=header(pos+posEq(1):end);
		else
			out=header(pos+posEq(1):pos+posRt(1)-2);
		end
		if convert
			out=str2num(out);
		end
	end
		
		
	