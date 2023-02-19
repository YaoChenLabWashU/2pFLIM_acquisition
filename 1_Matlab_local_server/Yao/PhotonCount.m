function PhotonCount
global spc
nChan=numel(spc.lifetimes);
for k=1:nChan; 
    gy(1,k)= sum(spc.lifetimes{k});
end; 
disp(gy);

end

