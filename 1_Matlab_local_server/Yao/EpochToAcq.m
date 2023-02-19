%% 
function MasterList = EpochToAcq(pathFolder, lastEpoch)
% pathFolder is where the path for a group of experiments are. All excel
% files under this folder will be analyzed to extract epoch to acq
% information. e.g. pathFolder='M:\Active\Aditi'
% lastEpoch is the last Epoch to be analyzed.

Filenames=FindExlFiles(pathFolder);

MasterList=cell(length(Filenames),3); % filename, start of acqs, end of the list acq.
Acqs=[];

for i=1:length(Filenames) % go through all the excel files to be examined.
    filename=Filenames{i,1}; % extract name of the file.
    MasterList{i,1}=filename(end-14:end); % file names go into the first column of MasterList.
    
    [num,txt,raw]=xlsread(filename,1,'A:C');
    clear num txt
    
    EpochFromXls=cell2mat(raw(26:1000,3));
    AcqFromXls=cell2mat(raw(26:1000,1));
    
    for epoch=1:lastEpoch
        rownumbers=find(EpochFromXls==epoch); % Get rownumbers
        if sum(rownumbers)>0 % if the epoch exists.
            beginningrow=rownumbers(1);
            Acqs=[Acqs AcqFromXls(beginningrow)];
            if epoch==lastEpoch | isempty(find(EpochFromXls==epoch+1))% is this the last epoch present or last Epoch we specified
                finalrow=rownumbers(end);
                final=AcqFromXls(finalrow);
            end
        end
    end
MasterList{i,2}=Acqs;
MasterList{i,3}=final;
Acqs=[];
final=0;

end





end

%% 



