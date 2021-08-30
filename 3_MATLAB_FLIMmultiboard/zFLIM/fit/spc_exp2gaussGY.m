function y = spc_exp2gaussGY(par, x)
global spc;
% this function is used for calculating the fit:
%  double exponential + gaussian PRF (with width of tau_g)

pulseI=spc.datainfo.pulseInt / spc.datainfo.psPerUnit*1000;

% GY: first get the parameters in order:
ampl = par(1);
tau1 = par(2); 
amp2 = par(3);
tau2 = par(4); 
tau_d = par(5);
tau_g = par(6);

y1 = ampl*exp(tau_g^2/2/tau1^2 - (x-tau_d)/tau1);
y2 = erfc((tau_g^2-tau1*(x-tau_d))/(sqrt(2)*tau1*tau_g));
y=y1.*y2;

%"Pre" pulse
y1 = ampl*exp(tau_g^2/2/tau1^2 - (x-tau_d+pulseI)/tau1);
y2 = erfc((tau_g^2-tau1*(x-tau_d+pulseI))/(sqrt(2)*tau1*tau_g));

ya = y1.*y2+y;
ya = ya/2;

y1 = amp2*exp(tau_g^2/2/tau2^2 - (x-tau_d)/tau2);
y2 = erfc((tau_g^2-tau2*(x-tau_d))/(sqrt(2)*tau2*tau_g));
y=y1.*y2;

y1 = amp2*exp(tau_g^2/2/tau2^2 - (x-tau_d+pulseI)/tau2);
y2 = erfc((tau_g^2-tau2*(x-tau_d+pulseI))/(sqrt(2)*tau2*tau_g));

yb = y1.*y2+y;
yb = yb/2;

y=ya+yb;