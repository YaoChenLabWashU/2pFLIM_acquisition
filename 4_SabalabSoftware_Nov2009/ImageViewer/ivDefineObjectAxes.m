function ivDefineObjectAxes(rerun, objects, timePoints, display)
	global state

	if nargin<4
		display=0;
	end
	
	if nargin<3
		timePoints=state.imageViewer.tsFileCounter;
	end
	
	if nargin<2
		objects=state.imageViewer.currentObject;
	end
	
	if isempty(timePoints)
		timePoints=1:state.imageViewer.tsNumberOfFiles;
	end
	
	if isempty(objects)
		if isempty(state.imageViewer.objStructs) %to fix bug where accidently pressing n before slecting the first object generates error due to reference to nonexistent box handle...
			disp('First Select Object') %ditto
			return
		else
			objects=1:size(state.imageViewer.objStructs,2);
		end
	end

	if nargin<1
		rerun=0;
	end
		
	for timePoint=timePoints
		ivFlipTimeSeries(timePoint)
		
		for objectNumber=objects
			if ~rerun
				ivBringSelectionToFront;	
				[xMajor, yMajor]=ginput(2);
				if size(xMajor, 1)~=2
					return
				end
			
				[xMinor, yMinor]=ginput(2);
				if size(xMinor,1)~=2
					return
				end
			
				xMajor=round(xMajor);
				yMajor=round(yMajor);
				xMinor=round(xMinor);
				yMinor=round(yMinor);
				
				state.imageViewer.objStructs(objectNumber).axis1x(timePoint, :) = xMajor;
				state.imageViewer.objStructs(objectNumber).axis1y(timePoint, :) = yMajor;
				state.imageViewer.objStructs(objectNumber).axis2x(timePoint, :) = xMinor;
				state.imageViewer.objStructs(objectNumber).axis2y(timePoint, :) = yMinor;
				state.imageViewer.objStructs(objectNumber).status(timePoint)=2;			% axis are defined
			end
			ivProcessAxisMorph(objectNumber, timePoint, display);
		end
	end
	
	

		