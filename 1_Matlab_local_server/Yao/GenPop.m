function GenPop = GenPop(TP, p1, p2, tau1, tau2);
%   This is a function to generate a population of lifetimes based on a double exponential exponential fit.  
%   TP=total number of photons at max in the histogram
%   p1 = fraction of population 1
%   p2 = fraction of population 2
%   tau1=real lifetime 1
%   tau2=real lifetime 2.

%   Section 1: generate an idealized double exponential fit.
%   First create x axis with 64 time channels from 0 to 12.5ns
xsim=linspace(0,12.5,64);
%   Then create y axis with double expnential
ysim=TP*(p1*exp(-xsim/tau1)+p2*exp(-xsim/tau2));
%   Shift y axis to the right to match prf shape.
ysimo(1:12)=ysim(53:64);
ysimo(13:64)=ysim(1:52);
% figure; 
% plot(xsim, ysimo);

%   Section 2: Turn the exponential histgram distribution into population
%   data.
%   First create a vector that converts the histogram to a population data.
Histogram=[xsim' ysimo'];
Population = [];
counter=1;
for i=1:64
    for j=1:int32(Histogram(i,2))
        Population(counter:(counter+int32(Histogram(i,2))-1))=Histogram(i,1);
    end
%    display(i);
    counter=counter+int32(Histogram(i,2))
end
figure;
plot(xsim, ysimo);
hold on;
Hist(Population, xsim, 'r');
display(length(Population));

save('DoubleExpPop', 'Population');
