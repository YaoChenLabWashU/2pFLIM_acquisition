function voltage=powerToPcellVoltage(power, chan)
	voltage=[];		% empty indicates error
	
	if nargin==1
		chan=1:size(power,2);
	elseif nargin~=2
		disp('*** powerToPcellVoltage: Two input arguments expected (percentage power, channel #');
		return
	elseif size(power,2)~=size(chan,2)
		disp('*** powerToPcellVoltage: Power and channel inputs mush be the same length');
		return
	end

	global state

	for counter=1:size(power, 2)
%		if eval(['size(state.pcell.powerLookupTable' num2str(chan(counter)) ',2)'])~=1001
% 			if getfield(state.pcell, ['pcellActive' num2str(chan(counter))])
% 				setStatusString(['No chan ' num2str(chan(counter)) ' pow table']);
% 				disp(['*** Need to calibrate pcell #' num2str(chan(counter)) ' ***  Assuming linear 0 to 100 %']);
% 			end
			voltage(counter)=power(counter)/50;	% 0 to 2 volts corresponds to 0 to 100 % power
	%	else
	%		voltage(counter)=eval(['state.pcell.powerLookupTable' num2str(chan(counter)) '(round(power(counter)*10)+1)']);
	%	end
	end