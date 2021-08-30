function fList=allFactors(n)
	list=zeros(1, n);
	list(1)=1;
	list(n)=1;
	fs=factor(n);
	if size(fs,2)>1
		for f=unique(fs)
			if ~list(n/f)
				list(allFactors(n/f))=1;
			end
			
		end
	end
	fList=find(list);
	clear list