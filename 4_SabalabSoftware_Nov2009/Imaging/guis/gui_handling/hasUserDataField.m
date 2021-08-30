function r=hasUserDataField(h, f)
% checks if a field exists within the 'UserData' of a particular handle
	if ishandle(h)
		ud=get(h, 'UserData');
		length(ud);
		if (length(ud)>0)
			r=isfield(ud, f);
		else
			r=0;
		end
	else
		r=0;
	end
	
	