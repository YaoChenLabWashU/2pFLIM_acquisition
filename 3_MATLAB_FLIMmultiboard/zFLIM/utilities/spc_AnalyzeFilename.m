function [filepath, basename, filenumber, max] = spc_AnalyzeFilename(filename)

filename_length = length(filename);
i = filename_length - 7;

%modified gy 20120202 to recognize either / or \ (MAC friendly)
while (filename(i)~='\' && filename(i)~='/' && i >= 1;
    i = i - 1;
end

if i <= 0
    error ('Not a valid filename')
end

filepath = filename(1:i);

if filename(end-7:end-4) == '_max'
    max = 1;
    filenumber = str2num(filename(end-10:end-8));
    basename = filename(i+1:end-11);
else 
    max = 0;
    filenumber = str2num(filename(end-6:end-4));
    basename = filename(i+1:end-7);
end
