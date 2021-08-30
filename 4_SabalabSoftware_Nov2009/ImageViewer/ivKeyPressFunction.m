function ivKeyPressFunction
	global gh state
	val = double(get(gcbo,'CurrentCharacter'))

	if ~isnumeric(val) | isempty(val)
		return
	end
	try
		switch val
		case 113 % q goto to frame 1
			ivFlipSlice(1);
		case 115 % s advance 1 frame
			ivFlipSlice(state.imageViewer.displayedSlice + 1);
		case 97 % a to reverse 1 frame
			ivFlipSlice(state.imageViewer.displayedSlice - 1);
		case 122 % z dim image
			t=get(gcf, 'Tag');
			chanS=t(end-1:end);
			chan=str2num(chanS);
			if isempty(chan)
				chanS=t(end);
				chan=str2num(chanS);
			end
			eval(['state.imageViewer.highLUT' chanS '=state.imageViewer.highLUT' chanS '/0.9;']);
			updateGUIByGlobal(['state.imageViewer.highLUT' chanS]);
			ivUpdateLUT(chan);
		case 120 % x dim image
			t=get(gcf, 'Tag');
			chanS=t(end-1:end);
			chan=str2num(chanS);
			if isempty(chan)
				chanS=t(end);
				chan=str2num(chanS);
			end
			eval(['state.imageViewer.highLUT' chanS '=0.9*state.imageViewer.highLUT' chanS ';']);
			updateGUIByGlobal(['state.imageViewer.highLUT' chanS]);
			ivUpdateLUT(chan);
		case 20 % ctrl + t Load new image to Top spine analysis
 			ivLoadStack;
		case 114 % r reset axis -- show whole image
			ivSetWindowBounds([1 state.imageViewer.nPixelsX], [1 state.imageViewer.nPixelsY]);
		case 49 % 1 show quadrant 1
			ivSetWindowBounds([1 round(1.1*state.imageViewer.nPixelsX/2)], [1 round(1.1*state.imageViewer.nPixelsY/2)]);
		case 50 % 2 show quadrant 2
			ivSetWindowBounds([round(0.9*state.imageViewer.nPixelsX/2) state.imageViewer.nPixelsX], ...
					[1 round(1.1*state.imageViewer.nPixelsY/2)]);
		case 51 % 3 show quadrant 3
			ivSetWindowBounds([1 round(1.1*state.imageViewer.nPixelsX/2)], ...
				[round(0.9*state.imageViewer.nPixelsY/2) state.imageViewer.nPixelsY]);
		case 52 % 4 show quadrant 4
			ivSetWindowBounds([round(0.9*state.imageViewer.nPixelsX/2) state.imageViewer.nPixelsX], ...
					[round(0.9*state.imageViewer.nPixelsY/2) state.imageViewer.nPixelsY]);
		case 96 % ` show all
			ivSetWindowBounds([1 state.imageViewer.nPixelsX], [1 state.imageViewer.nPixelsY]);
		case 109 % m mark object
			ivMarkObject;
		case 119 % w mark object
			ivMarkObject;
		case 77 % M redefine current object
			ivMarkObject(state.imageViewer.currentObject);
		case 87 % W redefine current object
			ivMarkObject(state.imageViewer.currentObject);
		case 105 % i move to first in time series
			ivFlipTimeSeries(1);
			ivHighlightObject;
		case 111 % o previous in time series
			ivFlipTimeSeries(state.imageViewer.tsFileCounter-1);
			ivHighlightObject;
		case 112 % p next in time series
			ivFlipTimeSeries(state.imageViewer.tsFileCounter+1);
			ivHighlightObject;
		case 91 % [ last in time series
			ivFlipTimeSeries(state.imageViewer.tsNumberOfFiles);
			ivHighlightObject;
		case 106 % j flip to first object
			ivHighlightObject(1);
		case 108 % l flip forward 1 object
			ivHighlightObject(state.imageViewer.currentObject+1);
		case 107 % k flip back 1 object
			ivHighlightObject(state.imageViewer.currentObject-1);
		case 59 % ; flip to last object
			ivHighlightObject(length(state.imageViewer.objStructs));
		case 46 % . play movie
			ivPlayMovie;
		case 44 % , play movie with object info
			ivPlayMovie(1);
		case 62 % > play movie backwards
			ivPlayMovie(0, 1);
		case 110 % n define major axes
			ivDefineObjectAxes(0, state.imageViewer.currentObject, state.imageViewer.tsFileCounter, 1);
		case 78 % N rerun analysis with predefine axis
			ivDefineObjectAxes(1, state.imageViewer.currentObject, state.imageViewer.tsFileCounter, 1);
		case 45 % - mark object gone
			ivMarkObjectGone;
		case 61 % = mark object here
			ivMarkObjectHere;
		case 68 % D delete object
			ivDeleteObject;
		case 32 % space bar -- step through each time point of each object and then the next object
			ivFlipNextPoint;
		case 82 % R reject object time point
			ivMarkObjectReject;
		case 102 % f Force reshift of axes from last timepoint
			if state.imageViewer.tsFileCounter>1
				state.imageViewer.objStructs(state.imageViewer.currentObject).status(state.imageViewer.tsFileCounter)=1;
				state.imageViewer.tsFileCounter=state.imageViewer.tsFileCounter-1;
				ivFlipNextPoint;
			else
				beep;
			end
		case 104 % h Shift the head
			ivShiftSpineHead;
		case 72 % H translate the head
			ivShiftSpineHead(1);
		case 116 % t getDendriteLength
			ivGetDendriteLength
		case 121 % y manually select the analysis box
			ivSelectAnalysisBox;
		case 89 % Y manually select a polygon as the analysis box; end selection with carriage return (turn analyze lines off and auto box off)
			ivSelectAnalysisBox(state.imageViewer.currentObject, 1, []);
		case 84 % T reset dendrite length
			state.imageViewer.tsDendriteLength(state.imageViewer.tsFileCounter) = 0;
			state.imageViewer.currentDendriteLength = 0;
			updateGUIByGlobal('state.imageViewer.currentDendriteLength')
		case 103
			ivMeasureAxisFluor;
		otherwise
		end
	catch
 		lasterr
	end
