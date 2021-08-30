function rgbimage=spc_drawPopulation(pop,chan)
% draws a population map of lifetime
global spc;
%global gui;

if nargin<2
    pop = [1,0];
end

[~, range] = spc_fitParamsFromGlobal(chan);
pos_max2 = spc.fits{chan}.figOffset;
if pos_max2 == 0 || isnan (pos_max2)
    pos_max2 = spc.datainfo.psPerUnit/1000; % GY changed from 1.0
    spc.fits{chan}.figOffset=pos_max2;
    spc_updateGUIbyGlobal('spc.fits',chan,'figOffset');
end

% try
%     spc_roi = get(gui.spc.projects{chan}.roi, 'Position');
% catch
%     spc_roi = [1,1,spc.size(3)-1, spc.size(2)-1];
% end

spc.projects{chan} = reshape(sum(spc.imageMods{chan}, 1), spc.size(2), spc.size(3));
spc.lifetimeAlls{chan} = reshape(sum(sum(spc.imageMods{chan}, 2), 3), spc.size(1), 1);

[~, pos_max] = max(spc.lifetimeAlls{chan}(range(1):1:range(2)));
pos_max = pos_max+range(1)-1;

x_project = 1:length(range(1):range(2));
x_project2 = repmat(x_project, [1,spc.size(2)*spc.size(3)]);
x_project2 = reshape(x_project2, length(x_project), spc.size(2), spc.size(3));
sumX_project = spc.imageMods{chan}(range(1):range(2),:,:).*x_project2;
sumX_project = sum(sumX_project, 1);

sum_project = sum(spc.imageMods{chan}(range(1):range(2),:,:), 1);
sum_project = reshape(sum_project, spc.size(2), spc.size(3)); 

spc.lifetimeMap = zeros(spc.size(2), spc.size(3));
bw = (sum_project > 0);
% lifetimeMap = spc.lifetimeMap;
% lifetimeMap(bw) = (sumX_project(bw)./sum_project(bw));
spc.lifetimeMaps{chan}(bw) = (sumX_project(bw)./sum_project(bw))*spc.datainfo.psPerUnit/1000-pos_max2;
lifetimeMap = spc.lifetimeMaps{chan} / spc.datainfo.psPerUnit* 1000;

% stop using spc.roipoly 201111 gy
% if isfield(spc, 'roipoly')
% 	spc.lifetimeMaps{chan}(~spc.roipoly{chan}) = spc.switchess{chan}.lifeLimitUpper;
% end

% GY: to this point, the calculation is exactly the same as the
% non-population calculation (i.e. calculate the empirical mean lifetime)

population = lifetimeMap;
tauD = spc.fits{chan}.beta0(2);
tauAD = spc.fits{chan}.beta0(4);
% GY
% based on tau(mean) calculate the fraction of tauAD (2nd tau) species
% including the fact that the slower decaying species automatically has
% more weight in the average, according to its tau
% so that prob density: p(t) = [f1 t1 exp(-t/t1) + (1-f1) t2 exp(-t/t2)] /
%                              [f1 t1 + (1-f1) t2]
%
population(bw) = tauD.*(tauD-lifetimeMap(bw))/(tauD-tauAD) ./ (tauD + tauAD -lifetimeMap(bw));

%figure; imagesc(population, [0,1]);

rgbimage = spc_im2rgb(population, pop);
low = spc.switchess{chan}.LutLower;
high = spc.switchess{chan}.LutUpper;

if high-low > 0
    gray = (spc.projects{chan}-low)/(high - low);
else
    gray = 0;
end
gray(gray > 1) = 1;
gray(gray < 0) = 0;
rgbimage(:,:,1)=rgbimage(:,:,1).*gray;
rgbimage(:,:,2)=rgbimage(:,:,2).*gray;
rgbimage(:,:,3)=rgbimage(:,:,3).*gray;

%figure; image(rgbimage);
%set(gca, 'XTick', [], 'YTick', []);