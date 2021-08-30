function flist = timerGetPackageNames
% get the contents of all directories named 'timerPackages'
allPackages=what('timerPackages');
numDirs=length(allPackages);
flist=allPackages(1).m;  % list of m-files in first dir
% concatenate if multiple directories
if numDirs>1
    for k=2:numDirs
        flist = [flist ; allPackages(k).m];
    end
end
% remove duplicates and sort alphabetically
flist = sort(unique(flist(strncmp('timerExists_',flist,12))));