%Put all AD1_ files for the experiment into a new folder before running
%script

files = dir('*.mat');
for i=1:length(files)
    eval(['load ' files(i).name ' -mat']);
end

clear files
clear i

%put data from all acquisitions together & get max value for each
%acquisition
AD1struc=who('AD1_*');
for i=1:length(AD1struc);
    allAD1.(strcat('data', num2str(i)))= max(eval([AD1struc{i} '.data'])); % max of AD1_number.data 
    if max(eval([AD1struc{i} '.data']))-2.5>2.5-min(eval([AD1struc{i} '.data'])) % resting=2.5
        allAD1absolute.(strcat('data', num2str(i)))= max(eval([AD1struc{i} '.data']));
    else
        allAD1absolute.(strcat('data', num2str(i)))= min(eval([AD1struc{i} '.data'])); % allAD1absolute takes the max or min of running speed, whichever is greater. Note: 
    end
end

% turn struct into array
arrayAD1(:,1)=AD1struc(:,1);
arrayAD1(:,2)=struct2cell(allAD1);
arrayAD1(:,3)=struct2cell(allAD1absolute);

% find index with specific string
index_AD1 = [];
max_voltage= [];
offset=19;
for k=1+offset:length(arrayAD1)+offset
    index_AD1(k,1) = find(ismember(arrayAD1(:,1), ['AD1_' num2str(k)]));
    max_voltage(k,1) = arrayAD1{index_AD1(k,1),2};
    max_voltage(k,2) = arrayAD1{index_AD1(k,1),3};
end

%save max voltage for each acquisition of the
%imaging session 
for n=1:length(max_voltage)
    running_data(n).acquisition= n;
    running_data(n).max_volt= max_voltage(n,1);
    running_data(n).absoluteMax=max_voltage(n,2);
end

save running_data running_data

figure;
plot([running_data.max_volt]);
hold on;
plot([running_data.absoluteMax]);