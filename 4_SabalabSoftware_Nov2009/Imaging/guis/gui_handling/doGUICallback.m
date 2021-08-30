function doGUICallback(handle)
% calls the Callback function of a GUI if one has been set by the user
	if hasUserDataField(handle, 'Callback')
		funcName=getUserDataField(handle, 'Callback');
		if exist(funcName)==2
			try
				eval([funcName '(handle);']);
			catch
				disp(['doGUICallBack: ' lasterr ' in ' funcName ]);
			end
		else
			if length(funcName)>0
				disp(['doGUICallback: Callback function (' funcName ') does not exist. No action.']);
			end
		end
	end
		