function FLIMsim2 = FLIMsim2(SS, DC, AF)
global n;
%   FLIMsim2 draws samples from a population of idealized lifetime
%   istribution.
%   SS=Sample Size
%   DC=Dark Counts (including dark count+ambient light).
%   AF=total photons from autofluorescence. This was 6424 for 20 frames
%   (~5s) for Autofluorescence_2FLIM001

%   Section 1: draw samples from the idealized population.  Sample with
%   replacement
load('DoubleExponentialPopulation(2.6_0.9_0.5_0.5).mat'); % This file contains 92808 data points of a double exponential fit, with taus 2.6 and 0.9, and relative distribution of 0.5 and 0.5
% r=rand(length(Population),1);
% display(length(Population));
% IndexedPopulation=[r Population'];
% SortedPopulation=sortrows(IndexedPopulation, 1);
% Sample=SortedPopulation(1:SS, 2);
Sample=Population(randi(length(Population), 1, SS)); 
% display(length(Sample));
% hist(Sample', 64);

%   Section 2: Draw samples for dark counts.  For reference, I measured
%   ~600photon/s as the dark counts.
DarkCounts=zeros(1, DC);
xsim=linspace(0,12.5,64);
DarkCounts=xsim(randi(length(xsim), 1, DC)); % Dark Counts are randomly and evenly distributed in lifetime bins.
% display(length(DarkCounts));
% figure;
% hist(DarkCounts, 64, 'r');
Sample=[Sample DarkCounts]; % Sample = signal+dark counts.  A vector of lifetimes.
% figure;
% display(length(Sample));
% hist(Sample, 64);

%   Section 3: now take into account of afterpulse: 1% of (signal+dark
%   counts)
Afterpulses=zeros(1, int32(0.01*(length(Sample)+AF))); % The number of afterpulses is 1% of total photon counts (signal+dark counts)
Afterpulses=xsim(randi(length(xsim), 1, int32(0.01*(length(Sample)+AF)))); % Afterpulses are randomly and evenly distributed in lifetime bins.  Note this is an assumption; in reality, they occur at distinct time points (e.g. 3) after photon signal.
% display(length(Afterpulses));
% figure;
% hist(Afterpulses, 64, 'b');
Sample=[Sample Afterpulses];
% figure;
% display (length(Sample));
% hist(Sample, 64);

%   Section 4: for each sample, convert it to a different lifetime based on
%   the prf lifetime distribution.
load('prfsim.mat'); % Load from measured prf in UREA_IRF_5 acqn 62, subtracted bg, divided by total number of photons.
SampleC=zeros(1, length(Sample));
for i=1:length(Sample)
    SampleC(i)=Sample(i)+(find(histc(rand(),[0;cumsum(prfsim(:))]))-13)*(12.5/64); % Randomly draw a distribution based on the probability specified in the prf.
    if SampleC(i)>12.5
        SampleC(i)=SampleC(i)-12.5; % Wrap around the distribution.
    else if SampleC(i)<0
        SampleC(i)=SampleC(i)+12.5; %Wrap around the distribution.
        end
    end
end
% display(length(SampleC));
% figure;
% hist(SampleC', 64, 'g');

%   Section 3: Add autofluorescence from slices.
load('AutoFluoSim.mat'); %Load from a probability distribution of autofluorescence in Autofluorescence_2FLIM001, measured at 30um below the surface of an 
%   untransfected slice, at 920nm, zoom 10, 2.5mW power.
Autofluorescence=zeros(1, AF); %Give each photon zero lifetime to start with.
for i=1:AF
    Autofluorescence(i)=find(histc(rand(),[0;cumsum(AutoFluoSim(:))]))*(12.5/64); % Draw a lifetime for autofluorescence based on the probability specified in the measured autofluorescence file.
end
SampleC=[SampleC Autofluorescence];
%   figure;
%   hist(Autofluorescence, 64);

% Section 6: Now turn the samples into histogram counts.
[n, xout]=hist(SampleC, 64);
% display(n);
% display(sum(n));
% display(xout);
% figure;
% bar(xout,n);

% Section 7: now save the numbers for analysis
save('FLIMSimulation', 'n', 'xout'); % n gives the photon count per bin; xout gives the lifetime position of each bin.
end

