function varargout=get(wavename, prop)% Overloaded method for classchar when the char represents a wave name.% Returns the prop if one is supplied, or returns a structure if no prop is% supplied.if iswave(wavename)
    if nargin==2        out=evalin('base', [wavename '.' prop]);
    elseif nargin==1        fn=evalin('base',['fieldnames(struct(' wavename '));']);        for prop=1:length(fn)            if prop==1                out=struct(fn{prop},evalin('base', [wavename '.' fn{prop}]));            else                out=setfield(out,fn{prop},evalin('base', [wavename '.' fn{prop}]));            end        end    else
        error('char/get : expect wavename and property as arguments');
    end
else
    error('char/get : no functionality for non wavename strings');
endif nargout == 0    disp(' ');    disp('ans = ');    disp(' ');    disp(out);elseif nargout==1    varargout{1}=out;else    error(['Error in get(wv,prop): invalid number of output arguments.'])end
