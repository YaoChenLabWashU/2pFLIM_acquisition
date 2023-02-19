function Filenames=FindExlFiles(pathFolder);

 
% The following lists all the folders (experiments) to be extracted from.
% pathFolder='M:\MICROSCOPE\Yao\microscopy\FLIM\AfterRigRebuilding2012\AfterSwitchingToNewVisionII\Analyzed\acuteHippo_AKAR6_Ach';
d=dir(pathFolder);
isub=[d(:).isdir];
subFolders={d(isub).name}';
subFolders(ismember(subFolders,{'.','..'})) = [];

% now let us find the relevant excel files.
Filenames=cell(length(subFolders),1);
for i=1:length(subFolders)
    subFolder=subFolders{i}; % folder of experiment - {} gives the text (content) in the cell.
    Index=strfind(subFolder,'(');
    if Index>1
        excelName=subFolder(1:Index-1); % name of the excel file.
    else
        excelName=subFolder;
    end
    Filenames{i,1}=sprintf('%s\\%s\\%s.xlsx', pathFolder, subFolder, excelName);
end

end
