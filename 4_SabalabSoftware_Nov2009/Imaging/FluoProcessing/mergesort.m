function [data, index, counter]=mergesort(data1, data2)


	done=0;

	counter1=1;
	counter2=1;
	
	if isempty(data1)
		if isempty(data2)
			data=[];
			index=[];
			counter=[];
			return
		else
			data=data2;
			index=2*ones(1,length(data2));
			counter=1:length(data2);
			return
		end
	elseif isempty(data2)
		data=data1;
		index=1*ones(1,length(data1));
		counter=1:length(data1);
		return
	end
	
	data=zeros(1, length(data1)+length(data2));
	index=data;
	counter=data;
	
	while ~done
		if data1(counter1)<data2(counter2)
			data(counter1+counter2-1)=data1(counter1);
			index(counter1+counter2-1)=1;
			counter(counter1+counter2-1)=counter1;
			counter1=counter1+1;
		else
			data(counter1+counter2-1)=data2(counter2);
			index(counter1+counter2-1)=2;
			counter(counter1+counter2-1)=counter2;
			counter2=counter2+1;
		end	
		
		if counter1>length(data1)
			data(counter1+counter2-1:end)=data2(counter2:end);
			index(counter1+counter2-1:end)=2;
			counter(counter1+counter2-1:end)=counter2:length(data2);
			done=1;
		elseif counter2>length(data2)
			data(counter1+counter2-1:end)=data1(counter1:end);
			index(counter1+counter2-1:end)=1;
			counter(counter1+counter2-1:end)=counter1:length(data1);
			done=1;
		end			
	end
			
			