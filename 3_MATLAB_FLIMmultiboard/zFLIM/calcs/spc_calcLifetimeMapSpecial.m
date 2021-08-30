function spc_calcLifetimeMapSpecial(chan)
% calculates lifetime map
% TODO gy multiFLIM 20111116
global spc

% we're here because this is a special channel
switch chan % get the correct definition
    case 5   % make this one sum of 1+2
        src1=1;
        src2=2;
    case 6
        src1=3;
        src2=4;
    otherwise
        disp(['spc_calcLifetimeMapSpecial ERROR ' num2str(chan)]);
        return
end

% calculate the lifetime map from the weighted average of the other two
nt=spc.projects{src1} .* spc.lifetimeMaps{src1}; % get Nphotons * mean tau
nt=nt+(spc.projects{src2} .* spc.lifetimeMaps{src2}); % get Nphotons * mean tau
nt=nt ./ spc.projects{chan}; % this channel's proj already has the sum
nt(isnan(nt))=0;

spc.lifetimeMaps{chan}=nt;
