function lmReadDAQs
	global state

	if ~state.lm.lineMonitorActive
		return
	end


	for counter=1:length(state.lm.devices)
		if ~isempty(state.lm.devices(counter).deviceHandle) ...
				&& isvalid(state.lm.devices(counter).deviceHandle)
			samp=getsample(state.lm.devices(counter).deviceHandle);
			for paramCounter=1:length(state.lm.devices(counter).params)
				param=state.lm.devices(counter).params(paramCounter);
				if getfield(state.lm, ['linear' num2str(param)])
					% it's linear, let's transform
					val=getfield(state.lm, ['linearOffset' num2str(param)]) + ...
						samp(paramCounter)*getfield(state.lm, ['linearSlope' num2str(param)]);
				elseif ~isempty(getfield(state.lm, ['transformFunction' num2str(param)]))
					val=eval([getfield(state.lm, ['transformFunction' num2str(param)]) ...
						'(samp(paramCounter))']);
				else
					val=samp(paramCounter);
				end
				sigDig=round(getfield(state.lm, ['sigDigits' num2str(param)]));
				if sigDig>=0
					sigDig=10^sigDig;
					eval(['state.lm.paramValue' num2str(param) '=round(val*sigDig)/sigDig;']);
				else
					eval(['state.lm.paramValue' num2str(param) '=val;']);
				end
				updateGUIByGlobal(['state.lm.paramValue' num2str(param)]);
			end
		else
			for paramCounter=1:length(state.lm.devices(counter).params)
				eval(['state.lm.paramValue' num2str(param) '=NaN;']);
				updateGUIByGlobal(['state.lm.paramValue' num2str(param)]);
			end
		end
	end