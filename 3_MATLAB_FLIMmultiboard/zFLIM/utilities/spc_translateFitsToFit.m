function spc_translateFitsToFit(chan)
% multiFLIM: translates from spc.fits{chan} (in ns units) to spc.fit (in points units)
global spc
nsPerPoint=spc.datainfo.psPerUnit/1000;

beta0(1)=spc.fits{chan}.beta1;
beta0(2)=spc.fits{chan}.beta2/nsPerPoint;
beta0(3)=spc.fits{chan}.beta3;
beta0(4)=spc.fits{chan}.beta4/nsPerPoint;
beta0(5)=spc.fits{chan}.beta5/nsPerPoint;
beta0(6)=spc.fits{chan}.beta6/nsPerPoint;
spc.fit.beta0=beta0;
nsRange=[spc.fits{chan}.fitstart spc.fits{chan}.fitend];
spc.fit.range=round(nsRange/nsPerPoint);

copyParams={'fixtau1' 'fixtau2' 'fix_delta' 'fix_g'};
for k=1:numel(copyParams)
    pName=copyParams{k};
    if isfield('spc.fits{chan}',pName)
        spc.fit.(pName)=spc.fits{chan}.pName;
    end
end
    
    
