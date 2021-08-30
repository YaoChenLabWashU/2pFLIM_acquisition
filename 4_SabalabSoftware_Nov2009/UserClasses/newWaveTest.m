function newWaveTest
tic;
for i=1:5
    waveNames{i}=['img' num2str(i)];
end
waveo(waveNames,rand(64,64));
appendimagesc(waveNames,'axes',-1);
setWave(waveNames([1 3]),'data',imread('rice.tif'));
waveo('sine',sin(0:.1:6.28),'xscale',[0 .1]);
waveo('cosine',cos(0:.1:6.28),'xscale',[0 .1]);
append('sine','axes',-1,'color','red','Marker','x');
appendr('cosine','axes',0,'color','blue','Marker','x');
appendxy('cosine','sine','axes',0,'color','black');
splayAxisTile('gapH',.1,'heightH',.8,'gapV',.1,'heightV',.8);
% collapseAxes(gcf);
setPlotProps(waveNames(1),'Position',[424   328   578   358]);
plotxy('sine','cosine','color','blue');
append('cosine','axes',0,'color','black');
splayAxisVertical('gapH',.1,'heightH',.8,'gapV',.1,'heightV',.8);
setPlotProps('cosine','Position',[21   328   395   358]);
waveo('newwave',(0:.1:6.28).^2);
duplicateo('newwave','sine');
waveo('empty',[],'xscale',[0 .1]);
appendDatao('empty',[]);
plot('empty','color','black','Marker','o');
setPlotProps('empty','Position',[19    66   987   186],'XLabel','\theta (Radians)','YLabel','Amplitude');
for i=0:.1:6.28
    appendDatao('empty',sin(i));
    drawnow;
end
toc;

