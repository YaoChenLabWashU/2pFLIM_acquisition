function lineLifetime = spc_calcLinescan(chan)
% TODO update this and calling routines for multiFLIM
global spc


try
    index = (spc.project >= spc.switches.lutlim(1));
    siz = size(index);
    %bw = (spc.lifetimeMap > 1);
    %index =index.*bw;        siz = size(index);	
	index = repmat (index(:), [1,spc.size(1)]);
	index = reshape(index, siz(1), siz(2), spc.size(1));
	index = permute(index, [3,1,2]);
    imageMod = index .*  reshape((spc.imageMod), spc.size(1), spc.size(2), spc.size(3));
catch
    imageMod = spc.imageMod;
    disp('LUT error');
end

lineMod = mean(imageMod, 3);

spc.fit.range = round(spc.fit.range);
range = spc.fit.range;
[maxcount, pos_max] = max(spc.lifetimeAlls{chan}(range(1):1:range(2)));
pos_max = pos_max+range(1)-1;

before = round(spc.switches.peak(1)*spc.size(1)/256);
after = round(spc.switches.peak(2)*spc.size(1)/256);

max_project = mean(lineMod((pos_max+before):1:(pos_max+after),:), 1);

sum_project = sum(lineMod(range(1):1:range(2),:), 1);

lineLifetime = zeros(spc.size(2));
bw = (max_project > 0);

lineLifetime(bw) = sum_project(bw)./max_project(bw)*spc.datainfo.psPerUnit/1000;
