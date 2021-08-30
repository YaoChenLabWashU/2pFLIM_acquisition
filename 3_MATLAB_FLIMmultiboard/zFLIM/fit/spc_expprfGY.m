function y = spc_expprfGY(par, x)
global spc;
% this function is used for calculating the fit:
%  single exponential + empirical PRF

% for multiFLIM, old usage is CORRECT (this is how we pass this info
range = spc.fit.range;

% background = mean(spc.lifetime(range(1):range(1)+10));
%background = 0;
%backprf = mean(spc.fit.prf(range(1):range(1)+10));

amp1 = par(1);
tau1 = par(2); 
deltapeak = par(5);
scatter = par(6);  % added gy 20120720 for scatter/SHG delta function
% if scatter<0  % put a clumsy limit on this to prevent negative vals
%     scatter=0;
% end

pulse_int = round(spc.datainfo.pulseInt*1000/spc.datainfo.psPerUnit);
prf1 = spc.fit.prf(range(1):range(2));
prf = interp1(x, prf1, x+deltapeak, 'linear');
prf(isnan(prf)) = 0;

lenx = length(x);
x = (0:lenx-1+pulse_int);  % gy changed 20120720 to start at zero
x = x(:);

lifetime = amp1*exp(-x/tau1);
lifetime(1)=lifetime(1)+scatter;  % added gy 20120720
y1 = conv(lifetime, prf);

y2 (1:lenx) = y1 (pulse_int+1:pulse_int+lenx);
y1 = y1(1:lenx);


y = y1(:) + y2(:);

% correct for BACKGROUND gy 20120718
y=spc_addBackgroundToFit(y);

% add a punishment for negative values of SHG gy 20130510
[~,locmin]=min(y);
if scatter<0
    y(1:locmin)=y(1:locmin)-10*exp(-scatter);
end