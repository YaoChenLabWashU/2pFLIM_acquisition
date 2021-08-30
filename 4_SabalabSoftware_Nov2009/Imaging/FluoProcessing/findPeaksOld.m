function [peakDefs, peakY]=findPeaks(data, nPeaks, offset, hwPer)
	peakDefs=[];
	peakY=[];
	
	len=size(data,2);
	seg=round(len/8);
	dataS=smooth(data,seg);
	dataS=dataS(seg+1:end);
	ds=smooth(diffN(data, seg), round(seg/2));
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
		
		peakDefs(1,counter)=min(regL)+seg-round(seg/2);
		peakDefs(2,counter)=max(regL)+seg-round(seg/2);
		peakY(1, counter)=data(peakDefs(1,counter));
		peakY(2, counter)=data(peakDefs(2,counter));
	end
		
	oldEnd=peakDefs(2,1); 
	for counter=2:nPeaks
		if peakDefs(1,counter)<oldEnd
			newEnd=(peakDefs(1,counter)+oldEnd)/2;
			peakDefs(1,counter)=ceil(newEnd);
			peakDefs(2,counter-1)=floor(newEnd);
			oldEnd=peakDefs(2,counter);
		end
	end
	
	peakY=peakY';
	peakDefs=peakDefs';
	