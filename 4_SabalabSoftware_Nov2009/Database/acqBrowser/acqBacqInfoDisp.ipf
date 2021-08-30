#pragma rtGlobals=1		// Use modern global access method.

function AcqInfoDisp_init()
	AcqInfoDisp_openwin()
end

function AcqInfoDisp_openwin()
	DoWindow/F AcqInfo
	wave /t vars=root:acqBrowser:valMapVar
	//here we could check if it exists
	if(v_flag==0 && waveexists(vars))
		variable nmaps=numpnts(vars)
		variable Gbot=320+22*nmaps+2
		variable i
		NewPanel/N=AcqInfo /W=(18,320,122,GBot)
		for(i=0;i<numpnts(vars);i+=1)
			execute "SetVariable setvar"+num2str(i)+",size={97, 16}, pos={5,"+num2str(i*22+2)+"}, limits={-inf,inf,0}, value="+gets("root:acqbrowser:foldername", "")+":"+vars[i]
			//execute "controlinfo setvar"+num2str(i)
			//nvar v_width
			//print v_width
			//execute "SetVariable setvar"+num2str(i)+",size={"+num2str(v_width+30)+", 16}"
		endfor
	endif
end

