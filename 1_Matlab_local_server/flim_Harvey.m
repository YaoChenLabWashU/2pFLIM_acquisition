

%%%%% calculate offset time
fracD = 0.6;
fracAD = 1 - fracD;

tauD = 2.14;
tauAD = 0.69;

% this estimates what you would get from eq S7 following fitting eq S3;
% calculated ti infinity
meanTau = (fracD*tauD^2+fracAD*tauAD^2)/(fracD*tauD+fracAD*tauAD);

t = 0:0.01:50;
F = fracD*exp(-t./tauD)+fracAD*exp(-t./tauAD);

% eq. S5 to 50 ns
intNum = 0;
intDenom = 0;
for i = 1:length(t)
    intNum = intNum + t(i)*F(i);
    intDenom = intDenom + F(i);
end
meanTime = intNum/intDenom;

% eq S6
tOffset = meanTime - meanTau;

% repeat for 12 ns
intNum2 = 0;
intDenom2 = 0;
temp = find(t < 12,1,'last');
for i = 1:temp
    intNum2 = intNum2 + t(i)*F(i);
    intDenom2 = intDenom2 + F(i);
end

meanTime2 = intNum2/intDenom2;
tOffset2 = meanTime2 - meanTau;


%%%%% calculate binding fraction for a new example
fracD = 0.75;
fracAD = 1 - fracD;

t = 0:0.01:50;
F = fracD*exp(-t./tauD)+fracAD*exp(-t./tauAD);

% eq S5 to 50 ns
intNum = 0;
intDenom = 0;
for i = 1:length(t)
    intNum = intNum + t(i)*F(i);
    intDenom = intDenom + F(i);
end

% eq S6
tau1 = intNum/intDenom - tOffset;

%eq S5 to 12 ns
intNum2 = 0;
intDenom2 = 0;
temp = find(t < 12,1,'last');
for i = 1:temp
    intNum2 = intNum2 + t(i)*F(i);
    intDenom2 = intDenom2 + F(i);
end

% eq S6
tau2 = intNum2/intDenom2 - tOffset2;

% eq S8
PAD1 = tauD*(tauD-tau1)/((tauD-tauAD)*(tauD+tauAD-tau1))
PAD2 = tauD*(tauD-tau2)/((tauD-tauAD)*(tauD+tauAD-tau2))


