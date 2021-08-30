function [peaks, acqTime]=findPeaks(start, stop)
	peaks=[];
	acqTime=[];
	for counter=start:stop
		
		try
			if iswave(ROIScanName(1, 1, counter))
				data=get(ROIScanName(1, 1, counter), 'data');
			else
				data=[];
			end
		catch
			lasterr
			data=[];
		end
		if ~isempty(data)
			baseline=mean(data(50:100));
			peak=mean(data(110:130));
			
			peaks(counter)=peak-baseline;
			try
				acqTime(counter)=extractWaveAcqTime(ROIScanName(1, 1, counter));
			catch
				counter
				lasterr
			end
		end
	end
	
		