function spc_adjustTauOffset(chan)
global spc

if ~(spc.fits{chan}.fixtau1 && spc.fits{chan}.fixtau2)
    errordlg ('Fix tau1 and tau2 !');
    return;
end

% get the lifetime data for the specified fit range
[~,range] = spc_fitParamsFromGlobal(chan);
t1 = (1:length([range(1):range(2)]));
t1 = t1(:);
lifetime = spc.lifetimes{chan}(range(1):range(2));
lifetime = lifetime(:);

a = sum(lifetime.*t1)/sum(lifetime)*spc.datainfo.psPerUnit/1000;

% uses avgTau OR avgTauTrunc (determined in spc.switches)
% gy 201111 should probably always use avgTauTrunc
spc.switchess{chan}.figOffset=a - spc.fits{chan}.avgTau; %YC: Different from Gary's version. offset calculated based on avgTau calculated to infinity so that the empirical lifetime is independent of fitting range.
% spc.switchess{chan}.figOffset=a - spc.fits{chan}.avgTauTrunc; % .average;
% spc.switchess{chan}.figOffset2=a - spc.fits{chan}.avgTau; %offset calculated based on avgTau calculated to infinity so that the empirical lifetime is independent of fitting range.
spc_updateGUIbyGlobal('spc.switchess',chan,'figOffset');

% at this point, the only thing that needs redrawing is the 
% lifetime map for this channel
spc_drawLifetimeMap(chan,1,0);
% gy 201112:
% also if there is a dependent channel (sum), then recalc/redraw it now
if ~isempty(spc.fits{chan}.dependentChan)
    spc_drawLifetimeMap(spc.fits{chan}.dependentChan,1);
end
spc_calculateROIvals(0);

% spc_redrawSetting(1); 

% gy 201111 - not sure why any of the below is needed - seems like
% redrawSetting should handle it.
return; % gy 201111

%%%%%%%%%%%%%%%%%%%%%%%%%%%% UNUSED NOW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lifetime = spc.lifetimes{chan}(range(1):1:range(2));
% x = [1:1:length(lifetime)];
% 
% % GY: added following conditional in order to use the prf fitting when it
% % has been used recently.  DOESN'T handle the 'triple' properly
% if isfield(spc.fit,'lastFitFunction') && ...
%         isempty(findstr(spc.fit.lastFitFunction,'gauss')) && ...
%         isempty(findstr(spc.fit.lastFitFunction,'triple'))
%     if spc.fit.fitOrder==1
%         fit = spc_reconv(beta0,x);
%     else
%         fit = spc_reconv2(beta0,x);
%     end
% else
%     fit = spc_exp2gaussGY(beta0, x);
% end
% t = [range(1):1:range(2)];
% t = t*spc.datainfo.psPerUnit/1000;
% spc_drawfit (t, fit, lifetime, beta0, chan);
% spc_dispbeta;
% 
