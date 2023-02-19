function SpcDataImport2=SpcDataImport2(times)
% First, open the files and create a matrix with it.
delimiterIn = ' ';
headerlinesIn = 10;

New = importdata('skf82 ip 3mg per kg at 10 min_c02.asc',delimiterIn,headerlinesIn);
for counter=3:times+1 % add files starting from cycle 2.
    if counter<10
        formatSpec='skf82 ip 3mg per kg at 10 min_c0%d.asc'; 
    else
        formatSpec='skf82 ip 3mg per kg at 10 min_c0%d.asc';
    end
    filename=sprintf(formatSpec,counter);
    NewFile=importdata(filename,delimiterIn,headerlinesIn); % Load the files and create a matrix.
    New.data=cat(1, New.data, NewFile.data);
end
save('mouse2', 'New');

% Could make filename an input parameter, and the saved file name another
% imput parameter.