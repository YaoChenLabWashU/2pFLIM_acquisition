function phReloadLoggedData(fileName)
	global state
	
	if (nargin<1) || isempty(fileName)
		[fname, pname]=uigetfile('*.daq', 'Choose data log file to load');
		if isempty(fname) || isnumeric(fname)
			return
		end
		fileName=fullfile(pname, fname);
	end
	
	
	try
		daqinfo = daqread(fileName,'info');
	catch
		error('phProcessLoggedData: Unable to load data from log file');
	end
	
	disp(['*** Reloaded logged data from ' fileName]);
	deltax=1/daqinfo.ObjInfo.SampleRate;
	eventLog=daqinfo.ObjInfo.EventLog;
	f=find(strcmp({eventLog.Type}, 'Trigger'));
	if isempty(f)
		disp('*** phProcessLoggedData: No trigger information found')
	else
		state.phys.internal.triggerClock=eventLog(f(1)).Data.AbsTime;
		updateMinInCell(state.phys.internal.triggerClock);
	end
	
	global physData
	physData=daqread(fileName)';
	if size(daqinfo.ObjInfo.Channel,2)~=size(physData,1)
		error('Loaded data and list of acquisition channels do not match');
	end
	
	for counter=1:size(daqinfo.ObjInfo.Channel,2)
		channel=daqinfo.ObjInfo.Channel(counter).HwChannel;

		physData(counter, :)=physData(counter, :)*state.phys.internal.channelGains(channel+1);
		waveo(['dataWave' num2str(channel)], physData(counter, :), ...
			'xscale', [0 1000/state.phys.settings.inputRate]);

	end
	