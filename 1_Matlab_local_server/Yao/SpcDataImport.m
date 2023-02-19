function SpcDataImport=SpcDataImport(times)
% First, open the files and create a matrix with it.
delimiterIn = ' ';
headerlinesIn = 10;

New = importdata('10 min home-10 min novel-then skf ip 5mg per kg_c02.asc',delimiterIn,headerlinesIn);
for counter=3:times+1 % add files starting from cycle 2.
    if counter<10
        formatSpec='10 min home-10 min novel-then skf ip 5mg per kg_c0%d.asc'; 
    else
        formatSpec='10 min home-10 min novel-then skf ip 5mg per kg_c%d.asc';
    end
    filename=sprintf(formatSpec,counter);
    NewFile=importdata(filename,delimiterIn,headerlinesIn); % Load the files and create a matrix.
    New.data=cat(1, New.data, NewFile.data);
end
save('mouse2', 'New');

% Could make filename an input parameter, and the saved file name another
% imput parameter.