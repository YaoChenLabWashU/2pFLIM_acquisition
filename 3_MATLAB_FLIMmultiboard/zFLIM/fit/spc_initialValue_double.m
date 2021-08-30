function beta0 = spc_initialValue_double(betaInit,lifetime,range,prfFlag)
% gy multiFLIM modified to work only with the supplied parameters
global spc
beta0=betaInit; % make a copy
nsPerPoint=spc.datainfo.psPerUnit/1000;
    b1 = max(lifetime);
    b2 = sum(lifetime)/b1;

% fix amplitudes if <0
if beta0(1) < 0 
    beta0(1)=b1*0.5;
end
if beta0(3) < 0
    beta0(3) = b1*0.5;
end
% fix taus if supershort
if beta0(2) <= 0.02/nsPerPoint % || beta0(2) >=1000/nsPerPoint
    beta0(2)=b2*1.2;
end
if beta0(4) <= 0.02/nsPerPoint % || beta0(4) >=1000/nsPerPoint
    beta0(4)=b2*0.3;
end
% fix gausswidth if outside (0,2] GY: don't do it if we are using PRF/SHG
if ~prfFlag && (beta0(6) < 0/nsPerPoint || beta0(6) >= 4/nsPerPoint)
    beta0(6) = 0.11/nsPerPoint;    
end
% fix delay if outside [-1,5]
if beta0(5) <= -1/nsPerPoint || beta0(5) >= 5/nsPerPoint 
    beta0(5) = 1/nsPerPoint;
end
