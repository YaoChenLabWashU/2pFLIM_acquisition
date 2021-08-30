function calibratePCell(chan)
	if nargin<1
		chan=1;
	end
	
	global gh
	setStatusString(['Pcell #' num2str(chan) ' calibrate...']);
	turnOffAllChildren(gh.pcellControl.figure1);
	try
		pcellTest(chan);
		makePcellLookupTable(chan);
	catch
		disp(['calibratePCell : Error in pcell calibration : ' lasterr]);
	end
	turnOnAllChildren(gh.pcellControl.figure1);
	setStatusString('Done');

	
