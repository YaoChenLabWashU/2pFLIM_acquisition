function selectAnalysisRange(fHandle)
	if nargin==1
		box=selectRange(fHandle);
	else
		box=selectRange;
	end

	global display_exp display_expRange
	if ~isempty(box)
		p=x2pnt(display_exp, box(1:2));
		waveo('display_expRange', display_exp(p(1):p(2)), 'xscale', [pnt2x(display_exp, p(1)) display_exp.xscale(2)]);
	end
	
	