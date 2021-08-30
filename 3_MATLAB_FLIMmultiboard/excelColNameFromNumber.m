function colName=excelColNameFromNumber(i)
letter=mod(i-1,26);
grp=floor((i-1)/26);
if grp==0
    colName=char(65+letter);
else
    colName=[char(64+grp) char(65+letter)];
end
