function spc_logscale
global spc FLIMchannels
if (spc.switches.logscale == 0)
    spc.switches.logscale=1;
else
    spc.switches.logscale=0;
end
for k=FLIMchannels
    spc_drawLifetime(k);
end