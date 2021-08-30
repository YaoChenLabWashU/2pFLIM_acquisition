function spc_dispbeta
% GY: displays fit parameters from the spc.fit.beta0 structure
%  but the fixed status of taus, delta, and gaussian come from the GUI
global gui;
global spc;

if isfield(spc.fit, 'beta0')
    
	handles = gui.spc.spc_main;
% GY: made all references directly 	betahat = spc.fit.beta0;

% in the data structure, tau values are in points
% need to convert to nanoseconds
	nsPerUnit=spc.datainfo.psPerUnit/1000;

	tau = spc.fit.beta0(2)*nsPerUnit;
	tau2 = spc.fit.beta0(4)*nsPerUnit;

	% GY: the range reference here seems to be in error
% 	peaktime = (spc.fit.beta0(5)+range(1))*spc.datainfo.psPerUnit/1000;
%	peaktime = (spc.fit.beta0(5)+spc.fit.range(1))*nsPerUnit;
	peaktime = (spc.fit.beta0(5))*nsPerUnit; % looks like error gave right result
    
	if length(spc.fit.beta0) >= 6
        tau_g = spc.fit.beta0(6)*nsPerUnit;
	end
 
% get these fix values from the GUI	
% GY: shouldn't need this if all of the fitting routines are fixed
    fix1 = get(gui.spc.spc_main.fixtau1, 'value');
    fix2 = get(gui.spc.spc_main.fixtau2, 'value');
    fix_g = get(gui.spc.spc_main.fix_g, 'value');
    fix_d = get(gui.spc.spc_main.fix_delta, 'value');

% POP1
    set(handles.beta1, 'String', num2str(spc.fit.beta0(1)));

% TAU1: if not fixed, set GUI; otherwise read value back    
	if ~fix1
    	set(handles.beta2, 'String', num2str(tau));
    else
        tau = str2double(get(handles.beta2, 'String'));
        spc.fit.beta0(2) = tau/nsPerUnit;
	end
	
% POP2
	set(handles.beta3, 'String', num2str(spc.fit.beta0(3)));

% TAU2: if not fixed, set GUI; otherwise read value back    
    if ~fix2
    	set(handles.beta4, 'String', num2str(tau2));
    else
        tau2 = str2double(get(handles.beta4, 'String'));
        spc.fit.beta0(4) = tau2/nsPerUnit;
	end
	
% Delta peak: if not fixed, set GUI; otherwise read value back
   if ~fix_d
    	set(handles.beta5, 'String', num2str(peaktime));
    else
        spc.fit.beta0(5) = str2double(get(handles.beta5, 'String'))/nsPerUnit;
   end
   
% Beta6(Gaussian width?): if not fixed, set GUI; otherwise read value back    
   if ~fix_g
        set(handles.beta6, 'String', num2str(tau_g));
    else
        spc.fit.beta0(6) = str2double(get(handles.beta6, 'String'))/nsPerUnit;
   end

% display the start and stop times
if isfield(spc.fit, 'range')
        range1 = round(spc.fit.range.*spc.datainfo.psPerUnit/100)/10;
        set(handles.spc_fitstart, 'String', num2str(range1(1)));
        set(handles.spc_fitend, 'String', num2str(range1(2)));
end

% Calculate and display population fractions
	pop1 = spc.fit.beta0(1)/(spc.fit.beta0(3)+spc.fit.beta0(1));
	pop2 = spc.fit.beta0(3)/(spc.fit.beta0(3)+spc.fit.beta0(1));
	set(handles.pop1, 'String', num2str(pop1,3));
	set(handles.pop2, 'String', num2str(pop2,3));
% Calculate and display mean tau from fit
    mean_tau = (tau*tau*pop1+tau2*tau2*pop2)/(tau*pop1 + tau2*pop2);
	spc.fit.avgTau=mean_tau;  % save this value
    
% Now estimate the truncation of the distribution between the 
%  peak of the lifetime distribution and the end
% Added by gy 20110307 for better estimation of Figure Offset
%  see modifications also to spc_adjustTauOffset
    tmax=(spc.fit.range(2)-spc.fit.range(1)-spc.fit.beta0(5))*spc.datainfo.psPerUnit/1000;
    % disp(['tmax =' num2str(tmax,3)]);  % for debugging
    % following formula from the definite integral from 0 to tmax
    %  of pop1*t*exp(-t/tau1) + pop1*t*exp(-t/tau2)
    % over the definite integral from 0 to tmax
    %  of pop1*exp(-t/tau1) + pop2*exp(-t/tau2)
    ff1=exp(-tmax/tau);
    ff2=exp(-tmax/tau2);
    spc.fit.avgTauTrunc = ...
       (pop1*(tau^2-(tau*(tau+tmax))*ff1) + pop2*(tau2^2-(tau2*(tau2+tmax))*ff2)) ...
        / (pop1*tau*(1-ff1) + pop2*tau2*(1-ff2));
% gy 20110307 - following lines choose between 
%   average Tau (integrated 0 to inf) or avgTauTrunc
    spc.switches.truncateIntegral = 1;
    if spc.switches.truncateIntegral
        set(handles.average, 'String', num2str(spc.fit.avgTauTrunc,3));
    else
        set(handles.average, 'String', num2str(spc.fit.avgTau,3));
    end
    
%     if isfield(spc.fit, 'fixtau1')
% 		set(handles.fixtau1, 'Value', spc.fit.fixtau1);
% 		set(handles.fixtau2, 'Value', spc.fit.fixtau2);
%     end
%     if isfield(spc.fit, 'fix_g')
%         set(handles.fix_g, 'Value', spc.fit.fix_g);
%     end
end

