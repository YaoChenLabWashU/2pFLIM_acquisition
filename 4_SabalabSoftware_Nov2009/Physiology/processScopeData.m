function processScopeData(ai, SamplesAcquired)
	global state
	
	data=getdata(ai);
	if state.phys.scope.needToStop
		stopScope;
	end

	if state.phys.scope.channelUsed==0
		if state.phys.scope.ccUsed
			gain=state.phys.settings.mVPerVIn0/state.phys.settings.inputGain0;
		else
			gain=state.phys.settings.pAPerVIn0/state.phys.settings.inputGain0;
		end
	elseif state.phys.scope.channelUsed==1
		if state.phys.scope.ccUsed
			gain=state.phys.settings.mVPerVIn1/state.phys.settings.inputGain1;
		else
			gain=state.phys.settings.pAPerVIn1/state.phys.settings.inputGain1;
		end
	else
		stopScope;
		disp('*** processScopeData: Scope channel out of range');
		setPhysStatus('ERROR');
		return;
	end

	state.phys.scope.input=data'*gain;
	if size(state.phys.scope.input,2)~=4*state.phys.scope.pointsUntilInputPulse
		disp('processScopeData: Mode must have changed.  Bypass data');
		startScopeLoop;
		return
	end
	
	% calculate the baseline based on all data before the pulse
	baseline = mean(state.phys.scope.input(1:state.phys.scope.pointsUntilInputPulse-1));
	if state.phys.scope.baselineSubtract
		state.phys.scope.input=state.phys.scope.input-baseline;
		baseline = 0;
	end
	
	% calculate the steady state from the last points in the pulse
	endline = mean(state.phys.scope.input(round(2.8*state.phys.scope.pointsUntilInputPulse) ...
		: 3*state.phys.scope.pointsUntilInputPulse-1));
	
	if state.phys.scope.ccUsed
		if state.phys.scope.ampUsed
			state.phys.scope.RIn=1000*(endline-baseline)/state.phys.scope.ampUsed;
		else
			state.phys.scope.RIn=0;
		end
	else
		state.phys.scope.RIn=1000*state.phys.scope.ampUsed/(endline-baseline);
	end
	
	if state.phys.scope.calcSeries && ~state.phys.scope.ccUsed && state.phys.scope.ampUsed~=0
		if state.phys.scope.ampUsed>0
			[peak, peakloc]=max(state.phys.scope.input);
        else
            [peak, peakloc]=min(state.phys.scope.input);
        end
        
        % Matlab polyfit to get tau & amp
% 		Data = state.phys.scope.input(peakloc:3*state.phys.scope.pointsUntilInputPulse-1)-endline;
% 		peak1=(peak-endline)*0.9; peak3=(peak-endline)*0.3; % Get data index for 10%, 50% 90% of the peak
% 		ix1=find(Data<peak1,1,'last'); ix3=find(Data<peak3,1,'last');
% 		fit=polyfit(ix1:ix3,log(-Data(ix1:ix3)),1); % fit
% 		tau=-1/fit(1); amp=-exp(fit(2));
        
        % Existing Code
		delta=round(0.1*state.phys.scope.pointsUntilInputPulse);
		peak1=peak-endline;
		peak2=state.phys.scope.input(delta+peakloc)-endline;
		peak3=state.phys.scope.input(2*delta+peakloc)-endline;
		peakloc=peakloc-state.phys.scope.pointsUntilInputPulse+1;
		tau=delta*(1/log(peak1/peak2)+1/log(peak2/peak3)+2/log(peak1/peak3))/3;
		amp=(peak1*exp(peakloc/tau)+peak2*exp((peakloc+delta)/tau)+peak3*exp((peakloc+2*delta)/tau))/3;
        
        
        state.phys.scope.Rs=round(10*1000*state.phys.scope.ampUsed/amp)/10;
        state.phys.scope.RIn=round(10*(state.phys.scope.RIn-state.phys.scope.Rs))/10;
        state.phys.scope.Cm=round(10*1000*1000*tau/state.phys.scope.actualInputRate/state.phys.scope.Rs)/10;
        
        updateGUIByGlobal('state.phys.scope.RIn');
		updateGUIByGlobal('state.phys.scope.Rs');	
		updateGUIByGlobal('state.phys.scope.Cm');	
        
		state.phys.scope.inputFit=amp*exp(-[0:2*state.phys.scope.pointsUntilInputPulse-1]/tau)+endline;
		setWave('scopeInputFit', 'data', state.phys.scope.inputFit);
		
		state.phys.scope.RsAvg= round(10*...
			(state.phys.scope.RsAvg*state.phys.scope.counter+state.phys.scope.Rs)/(state.phys.scope.counter+1))/10;
		state.phys.scope.CmAvg= round(10*...
			(state.phys.scope.CmAvg*state.phys.scope.counter+state.phys.scope.Cm)/(state.phys.scope.counter+1))/10;
		updateGUIByGlobal('state.phys.scope.RsAvg');
		updateGUIByGlobal('state.phys.scope.CmAvg');
	else
		setWave('scopeInputFit', 'data', []);
		updateGUIByGlobal('state.phys.scope.RIn');
	end
	
	state.phys.scope.RInAvg=round(10*...
		(state.phys.scope.RInAvg*state.phys.scope.counter+state.phys.scope.RIn)/(state.phys.scope.counter+1))/10;
	state.phys.scope.counter=state.phys.scope.counter+1;
	updateGUIByGlobal('state.phys.scope.RInAvg');
	
	setWave('scopeInput', 'data', state.phys.scope.input);
	eventLog=get(ai, 'EventLog');
	f=find(strcmp({eventLog.Type}, 'Trigger'));
	if isempty(f)
		stopScope;
		disp('*** processScopeData: ERROR:  No trigger information returned');
		return
	end
%	state.phys.daq.scopeTriggerTime=eventLog(f(1)).Data.AbsTime;
	
	if state.phys.scope.needToStop
		stopScope;
	else
		startScopeLoop;
	end