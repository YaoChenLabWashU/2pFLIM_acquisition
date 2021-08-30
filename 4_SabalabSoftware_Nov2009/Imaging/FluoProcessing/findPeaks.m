function [peakDefs, peakY]=findPeaks(data, nPeaks, offset, hwPer)
	peakDefs=[];
	peakY=[];
	
	len=size(data,2);
	seg=round(len/30);
	dataS=smooth(data,seg);
	dataS=[repmat(0, 1, ceil(seg/2)) dataS(seg+1:end) repmat(0, 1, floor(seg/2))];
	ds=[repmat(0, 1, ceil(seg/2)) smooth(diffN(data, seg), round(seg/2)) repmat(0, 1, floor(seg/2))];
	peaks=(ds>0) & (dataS>offset);
	valleys=(ds<0);
	peakL=bwlabel(peaks, 4);
	nP=max(peakL);
	peakRank=[]; 
	rankInd=[];
	for counter=1:nP
		reg=find(peakL==counter);
		[peakRank(counter), rankInd(counter)]=max(dataS(reg));
		rankInd(counter)=rankInd(counter)+min(reg)-1;
	end
	
	[pr, ind]=sort(peakRank);
	if size(pr,2)<nPeaks
		disp('*** findPeaks : insufficient peaks : CHANGE # ROI');
		beep
		return
	end
	
	ind=sort(ind(end-nPeaks+1:end));
	
	peakDefs=zeros(2,nPeaks);
	peakY=zeros(2,nPeaks);
	for counter=1:nPeaks
		val=ind(counter);		
		reg=dataS>(offset+hwPer*(peakRank(val)-offset));
		regL=bwlabel(reg, 4);
		indPeak=regL(rankInd(val));
		regL=find(regL==indPeak);
		
		peakDefs(1,counter)=min(regL); %+seg-round(seg/2);
		peakDefs(2,counter)=max(regL); %+seg-round(seg/2);
		peakY(1, counter)=data(peakDefs(1,counter));
		peakY(2, counter)=data(peakDefs(2,counter));
	end
		
	oldEnd=peakDefs(2,1); 
	dsZeros=[((ds(1:end-1).*ds(2:end))<0) 0];
	
	for counter=2:nPeaks
		if peakDefs(1,counter)<oldEnd
			start=rankInd(ind(counter-1));
			stop=rankInd(ind(counter));
			
			[minVal, minInd]=min(data(start:stop));	%find(dsZeros(start:stop))+start-1;
			newEnd=minInd+start-1;

			peakDefs(1,counter)=newEnd;
			peakDefs(2,counter-1)=newEnd;
			peakY(1, counter)=data(newEnd);
			peakY(2, counter-1)=data(newEnd);
			oldEnd=peakDefs(2,counter);
		end
	end
	
	peakY=peakY';
	peakDefs=peakDefs';
	