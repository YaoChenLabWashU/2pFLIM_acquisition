function freeze(axishandle)
% Function locks scale and the resacaleAxis function will not operate on it.
% USe release(ax) to allow autoscale to commence.
%
% Sets the axis UserData.autoscale=0 on the ax.
%

if nargin == 0	% No inputs...look for GCA
	axParents=findobj(gcf, 'Type', 'axes');
	if ~isempty(axParents)
		axList=axParents;
	else
		axList=gca;
	end
elseif nargin==1	% axis handle...check
	if istype(axishandle,'axes')
		axList=axishandle;
	else
		error('freeze: Bad Axes handle.');
	end
else
	error('freeze: too many inputs. Only input is axis handle.')
end

for counter=1:length(axList)
	ax=axList(counter);
	userData = get(ax, 'UserData'); % Check if frozen....the dont autoscale.
	if isstruct(userData)	% Check format...
		if isfield(userData, 'autoScale')
			userData=setfield(userData, 'autoScale', 0); 	%Dont AutoScale
			set(ax,  'UserData', userData);
		else
			return	
		end
	else
		userData=setfield(userData, 'autoScale', 0); 	%Dont AutoScale
		set(ax,  'UserData', userData);
	end

	rescaleAxis(ax);	%Now just sets the update modes for the axis to manual
end

