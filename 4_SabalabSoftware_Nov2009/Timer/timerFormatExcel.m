function timerFormatExcel
	global state
	
	ddepoke(state.internal.excelChannel, 'r3c1', 'Start Time');
	ddepoke(state.internal.excelChannel, 'r3c2', state.internal.startupTimeString);
	ddepoke(state.internal.excelChannel, 'r4c1', 'Basename');
	ddepoke(state.internal.excelChannel, 'r4c2', state.files.baseName);
	ddepoke(state.internal.excelChannel, 'r5c1', 'SavePath');
	ddepoke(state.internal.excelChannel, 'r5c2', state.files.savePath);
	ddepoke(state.internal.excelChannel, 'r6c1', 'Species');
	ddepoke(state.internal.excelChannel, 'r7c1', 'Age');
	ddepoke(state.internal.excelChannel, 'r8c1', 'DOB');
	ddepoke(state.internal.excelChannel, 'r9c1', 'DIV');
	ddepoke(state.internal.excelChannel, 'r10c1', 'DPT');	
	ddepoke(state.internal.excelChannel, 'r11c1', 'Temp');
	ddepoke(state.internal.excelChannel, 'r12c1', 'Internal');
	ddepoke(state.internal.excelChannel, 'r13c1', 'External');
	ddepoke(state.internal.excelChannel, 'r14c1', 'Drugs');
	ddepoke(state.internal.excelChannel, 'r15c1', 'Comments');
	ddepoke(state.internal.excelChannel, 'r16c1', 'Rationale');
	
	items={'acq #', 'eTime', 'epoch', 'cycle', 'cyclePos', 'analysis'};
	for itemCounter=1:length(items)
		ddepoke(state.internal.excelChannel, ['r25c' num2str(itemCounter)], items{itemCounter});
	end

	ddepoke(state.internal.excelChannel, 'r24c10', 'IMAGING');
	items={...
			'acq #', 'epoch', 'radius', 'config', 'frames', 'avg', 'slices', 'zoom', 'rotation', ...
			'linescan', 'blaster', 'b setup', 'b config', 'b name', ...
			'tracker', 'offset1', 'offset2', 'offset3', 'binFactor'};
	for itemCounter=1:length(items)
		ddepoke(state.internal.excelChannel, ['r25c' num2str(itemCounter+9)], items{itemCounter});
	end
	
	ddepoke(state.internal.excelChannel, 'r24c30', 'PHYSIOLOGY');
	items={'acq #', 'epoch', 'pat set', 'pat 0', 'pat 1', 'extra gain0', 'extra gain1', 'min0', 'cc0', 'vm0', 'im0', ...
			'rm0', 'rs0', 'cm0', 'min1', 'cc1', 'vm1', 'im1', 'rm1', 'rs1', 'cm1', ...
			};
	for itemCounter=1:length(items)
		ddepoke(state.internal.excelChannel, ['r25c' num2str(itemCounter+29)], items{itemCounter});
	end

	
	ddepoke(state.internal.excelChannel, 'r24c57', 'FLUOR TRACE ANALYSIS');
	ddepoke(state.internal.excelChannel, 'r25c57', 'acq #');
	ddepoke(state.internal.excelChannel, 'r25c58', 'epoch'); 
	ddepoke(state.internal.excelChannel, 'r25c59', 'pat 0');
	ddepoke(state.internal.excelChannel, 'r24c107', 'PHYS TRACE ANALYSIS');
	ddepoke(state.internal.excelChannel, 'r25c107', 'acq #');
	ddepoke(state.internal.excelChannel, 'r25c108', 'epoch');
	ddepoke(state.internal.excelChannel, 'r25c109', 'pat 0');
	