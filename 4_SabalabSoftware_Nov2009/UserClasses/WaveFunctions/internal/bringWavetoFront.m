function bringWavetoFront(wv,axishandle)
% THis function will bring any plots containing the wave 
% to the front.  If only one input is supplied, it will do it for each
% plot in all open axes.  
% The specified axis can also be included.
% wv may also be a char.

if nargin == 0	% No inputs...look for GCA
	error('bringWavetoFront: No Wave specified.');
elseif nargin==1	% Only supplied wave.,..no axis handle.
	a=findobj('Type', 'axes');  % Are there any axes?
	if ~isempty(a)              
		ax=a;
	else
		return
	end
elseif nargin == 2	%supplied there own axis.
	if istype(axishandle,'axes')
        ax=axishandle;
    else      
        error('bringWavetoFront: invalid axes handle.');
    end
else
	error('bringWavetoFront: too many inputs')
end
if iswave(wv)
	plothandles=wv.plot;
	if isempty(plothandles)
		return
	end
elseif ischar(wv)
	plothandles=evalin('base',[wv '.plot']);
	if isempty(plothandles)
		return
	end
end

top=[];
bottom=[];

for j = 1:length(ax) % look at all the axes specified.
	a = get(ax(j), 'Children');	% Get the children of each one...
	for i = 1:length(a)
		if any(plothandles == a(i))	% Is this handle on the plot?
			top = [top ; a(i)];     % lines go on top...
		else
			bottom = [bottom; a(i)];
		end
	end
	set(ax(j), 'Children', [top;bottom]);
	top=[];
	bottom=[];
end


