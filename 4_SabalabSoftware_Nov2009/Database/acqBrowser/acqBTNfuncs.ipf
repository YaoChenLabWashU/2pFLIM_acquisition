#pragma rtGlobals=1		// Use modern global access method.

addfunction("SubBaseline", "doforeachacqinset(\"subbaseline()\")")

function SubBaseline()
	svar wpointer=root:acqbrowser:ad0_name
	wave w=$wpointer
	if(waveexists(w))
		variable avg=mean(w, 0.5, 4.9)
		w-=avg
	endif
end
