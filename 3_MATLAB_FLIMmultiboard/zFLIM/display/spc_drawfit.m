function spc_drawfit (t, fit, lifetime, beta0, chan)
% draws newly computed fit for chan.  multiFLIM gy 20111116
global spc;
global gui;
% note that the parameters are already restricted to the fitting range (GY)
%figure(gui.spc.figure.lifetime);
%lifetime = spc.lifetime(range(1):1:range(2));

residual = lifetime(:) - fit(:);
% GY: added chi-square calculation
% chisq = sum(residual(:).*residual(:) ./ lifetime(:)); 
% GY changed 20110517 to following
chisq = sum(residual(:).*residual(:) ./ max(fit(:),1)); % should divide by the fit (expected)
  % above corrected 20130510 to avoid problems from negative values
redchisq = chisq/(length(lifetime)-spc.fits{chan}.nFreeParams);
% this definition of reduced chisq corrects for degrees of freedom
% but erroneous fits also differ by a fraction of the total amplitude
% so here it COULD BE calculated divided by the max ???
% NOT changed by gy 20111209
% redchisq=100*redchisq/(max(lifetime));
spc.fits{chan}.redchisq=redchisq;
spc.fits{chan}.chisq=chisq;

% now display chisq in little boxes on lifetime window
set(gui.spc.chisq(chan),'String',num2str(redchisq,4));


set(gui.spc.figure.lifetimePlot(chan), 'XData', t, 'YData', lifetime(:));
set(gui.spc.figure.fitPlot(chan), 'XData', t, 'YData', fit);

if (spc.switches.logscale == 0)
    set(gui.spc.figure.lifetimeAxes, 'YScale', 'linear');
else
    set(gui.spc.figure.lifetimeAxes, 'YScale', 'log');
end;

set(gui.spc.figure.lifetimeAxes, 'XTick', []);

eval ('res = residual;', 'res = 0;');
if (res ~= 0 & length(t) == length(res))
    set(gui.spc.figure.residualPlot(chan), 'XData', t, 'YData', res);
end

% changed to store in modern cell form gy 20120718
spc.fits{chan}.curve = fit;
spc.fits{chan}.residual = residual;
spc.fits{chan}.beta0 = beta0;