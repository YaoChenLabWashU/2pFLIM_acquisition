function out = get(wv, prop)
	if nargin == 1
		fn=fieldnames(wv);
		out=[];
		for counter=1:length(fn)
            out=setfield(out, fn{counter}, eval(['wv.' fn{counter}]));
        end
	elseif nargin == 2
		try %fitz, error catching
            out=eval(['wv.' prop]);
        catch
            out=[];
        end
	else
		error(['Error in get(wv,prop): invalid number of input parameters.'])
	end
	
