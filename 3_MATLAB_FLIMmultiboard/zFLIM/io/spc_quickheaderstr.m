function headerstr = spc_quickheaderstr
global spc
global state

changingStr = {'spc.datainfo.triggerTime', 'spc.datainfo.multiPages.page', 'spc.datainfo.time', 'spc.datainfo.date', ...
    'spc.scanHeader.internal.triggerTimeString'};
strStr = [1, 0, 1, 1, 1];

for i=1:length(changingStr)
    line1 = strfind(spc.headerstr, [changingStr{i}, ' = ']);
    line2 = strfind(spc.headerstr(line1:min(line1+100, length(spc.headerstr))), ';');
    
    if length(line2) > 0
        line2 = line1 + line2(1) - 2;
        lineStr = spc.headerstr(line1:line2);
        if strStr(i)
            str1 = eval(changingStr{i});
            str1 = [str1, '        '];
            length1 = length(spc.headerstr(line1+ length(changingStr{i})+ 3 + 1 : line2 - 1));
            spc.headerstr(line1+ length(changingStr{i})+ 3 + 1 : line2 - 1) = str1(1:length1);
        else
            str2 = num2str(eval(changingStr{i}));
            str2 = [str2, '        '];
            length2 = length(spc.headerstr(line1+ length(changingStr{i})+ 3  : line2));
            %str2(1:length2)
            spc.headerstr(line1+ length(changingStr{i})+ 3 : line2) = str2(1:length2);
        end
    end
    %% + 1, -1 is for ''
end