function dataMajor=ivImageProfile(channel, useProjection, lineBlur, xMajor, yMajor)
	global state
	
	lenMajor=sqrt((xMajor(2)-xMajor(1))^2+(yMajor(2)-yMajor(1))^2);
	dxMajor=(xMajor(2)-xMajor(1))/lenMajor;
	dyMajor=(yMajor(2)-yMajor(1))/lenMajor;
	maxd=max(abs(dxMajor), abs(dyMajor));
	dxMajor=dxMajor/maxd;
	dyMajor=dyMajor/maxd;
		
	first=1;
	scale=1+2*lineBlur;
	
	for counter = -lineBlur:lineBlur
		if useProjection
			newMajor=improfile(state.imageViewer.tsCoredFlatProjection{state.imageViewer.tsFileCounter, channel}, ...
				xMajor + dyMajor*counter, yMajor - dxMajor*counter)'/scale;	
		else
			newMajor=improfile(state.imageViewer.displaySliceData{channel}, ...
				xMajor + dyMajor*counter, yMajor - dxMajor*counter)'/scale;	
		end

		if first
			dataMajor=newMajor;
			first=0;
		else
			if length(newMajor)~=length(dataMajor)
				minLen=min(length(newMajor), length(dataMajor));
				dataMajor(1:minLen)=dataMajor(1:minLen)+newMajor(1:minLen);	
			else
				dataMajor=dataMajor+newMajor;
			end
		end
	end
