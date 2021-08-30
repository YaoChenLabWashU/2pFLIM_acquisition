#pragma rtGlobals=1		// Use modern global access method.
#include "justfilters"

function ABminis_init()
	string folder="root:acqbrowser:abminis"
	ensurevar(folder+":tto", 5000)
	ensurevar(folder+":tfrom", 100)
	ensurevar(folder+":flow", 25)
	ensurevar(folder+":fhigh", 25)	
	ensurevar(folder+":refrac", 10)
	ensurevar(folder+":thres", 3)
	ensurevar(folder+":curr_mini", 0)
	ensurevar(folder+":ampthres", -4)
	ensurevar(folder+":derivthres", -7)
	

	ABminis_openwin()

end

function ABminis_openwin()
	DoWindow/F mini_panel
	//here we could check if it exists
	if(v_flag==0)
		execute "mini_panel()"
	endif
end

function ABminis_updateacq()
end

Window mini_panel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(125,555,282,748)
	SetDrawLayer UserBack
	DrawText 62,61,"SD's"
	SetVariable SAMA_tfrom,pos={6,6},size={89,16},title="anal. from"
	SetVariable SAMA_tfrom,limits={0,100000,0},value= root:acqBrowser:abminis:tfrom
	SetVariable SAMA_tto,pos={97,6},size={46,16},title="to"
	SetVariable SAMA_tto,limits={0,100000,0},value= root:acqBrowser:abminis:tto
	PopupMenu popup0,pos={6,73},size={83,21},proc=MiniFunctions,title="Functions"
	PopupMenu popup0,mode=0,value= #"\"Detect\""
	SetVariable SAMA_smooth,pos={7,26},size={58,16},title="flow"
	SetVariable SAMA_smooth,limits={0,100000,0},value= root:acqBrowser:abminis:flow
	SetVariable SAMA_smooth1,pos={79,26},size={65,16},title="fhigh"
	SetVariable SAMA_smooth1,limits={0,100000,0},value= root:acqBrowser:abminis:fhigh
	SetVariable SAMA_lvl,pos={8,46},size={50,16},title="thres"
	SetVariable SAMA_lvl,limits={0,10000,0},value= root:acqBrowser:abminis:thres
	SetVariable SAMA_refrac,pos={98,46},size={46,16},title="refr"
	SetVariable SAMA_refrac,limits={0,100000,0},value= root:acqBrowser:abminis:refrac
	SetVariable setCurrentMini,pos={14,103},size={70,16},proc=SetVarProc,title="#"
	SetVariable setCurrentMini,value= root:acqBrowser:abminis:curr_mini
	Button butDelMini,pos={94,100},size={50,20},proc=ButtonProc_2,title="Kill"
EndMacro

Function MiniFunctions(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr

	switch(popNum)
		case 1: //detect minis
			killwaves/z root:minilist_wname
			killwaves/z root:minilist_amp
			killwaves/z root:minilist_rt
			killwaves/z root:minilist_bl
			killwaves/z root:minilist_peakderiv
			killwaves/z root:minilist_tcrossing
			
			doforeachacqinset("detect_minis_on_current()")
		break
	endswitch

End

function detect_minis_on_current()
	string wname=gets("root:acqbrowser:ad0_name", "")
	wave w=$wname

	variable level, i


	//print gets("root:acqbrowser:ad0_name", "")

	if(!waveexists(w))
		//print "hello"
		return 0
	endif
	
	duplicate /o/r=(get("root:acqbrowser:abminis:tfrom", 0), get("root:acqbrowser:abminis:tto", 100)) w mywave
	
	wavestats/q mywave
	
	mi_FastBPFilter(mywave, get("root:acqbrowser:abminis:flow", 0), get("root:acqbrowser:abminis:fhigh", 1000), 4)

	wavestats/q mywave
	
	level=-get("root:acqbrowser:abminis:thres", 3)*v_sdev-v_avg
	
	//print level
	
	findlevels/q mywave level
	wave xings=w_findlevels
	
	duplicate /o mywave diff
	differentiate diff

	//duplicate /o diff diff2
	//differentiate diff2

	make/o/n=0 events
	
	variable last_mini=-1000
	for(i=0;i<numpnts(xings);i+=1)
		//print levels2[i]
		if(diff(xings[i])<0 && xings[i]>last_mini+get("root:acqbrowser:abminis:refrac", 10))
			elong(events, xings[i])
			last_mini=xings[i]
			analyse_mini(mywave, xings[i])
		endif
	endfor

end

function analyse_mini(ad0, tcrossing)
	wave ad0
	variable tcrossing
	
	
	variable local_bl, tpeak
	
	wave diff
	
	string ad0_name=gets("root:acqbrowser:ad0_name", "")
	
	//print tcrossing

	//print ""
	variable amp, t20, t80
	wavestats/q/r=(tcrossing, tcrossing+5) ad0
	
	amp=v_min
	tpeak=v_minloc
	findlevel/q/r=(tcrossing-5, tcrossing+1) ad0 0.2*amp
	t20=v_levelx

	findlevel/q/r=(tcrossing-1, tcrossing+5) ad0 0.8*amp
	t80=v_levelx
 

	wavestats/q/r=(tcrossing-5, tcrossing-4) ad0
	local_bl=v_avg
	
	wavestats/q/r=(tcrossing-2, tcrossing+2) diff
	
	
	if((amp-local_bl)>get("root:acqbrowser:abminis:ampthres", -4)) //amp is negative
		printf "."
		return -1
	endif
	
	if(v_min>get("root:acqbrowser:abminis:derivthres", -7)) //amp is negative
		//printf ","
		return -1
	endif
	
	//printf "!"
	
	appendtextval("root:acqbrowser:abminis:list_wname", ad0_name)
	appendval("root:acqbrowser:abminis:list_amp", amp)
	appendval("root:acqbrowser:abminis:list_rt", t80-t20)	
	appendval("root:acqbrowser:abminis:list_tpeak", tpeak)
	appendval("root:acqbrowser:abminis:list_tcrossing", tcrossing)	
	appendval("root:acqbrowser:abminis:list_peakderiv", v_min)	
	
end

function freq()
	variable nminis
	variable nwaves
	variable totaltime
	
	wave amps=root:acqbrowser:abminis:list_amp
	nminis=numpnts(amps)
	wave avset=$gets("root:acqbrowser:currentset_name", "")
	nwaves= mean(avset)*numpnts(avset)
	
	totaltime=(get("root:acqbrowser:abminis:tto", 0)-get("root:acqbrowser:abminis:tfrom", 100))*nwaves/1000
	
	return nminis/totaltime
end

function viewMini(n)
	variable n
	wave /t wn=root:acqbrowser:abminis:list_wname
	wave tc=root:acqbrowser:abminis:list_tcrossing
	wave rt=root:acqbrowser:abminis:list_rt
	
	wave amp=root:acqbrowser:abminis:list_amp

	wave src_wave=$wn[n]
	
	//wavestats/q/r=(get("root:minis_tfrom", 0), get("root:minis_tto", 100)) src_wave
	
	duplicate /o/r=(tc[n]-5, tc[n]+get("root:minis_refrac", 10)) src_wave root:acqbrowser:abminis:current_mini_wave

	wave mini=root:acqbrowser:abminis:current_mini_wave
	
	//mini-=bl[n]
			
	//print tc[n], rt[n], amp[n]
	
	set("root:acqbrowser:abminis:current_mini_rt", rt[n])
	set("root:acqbrowser:abminis:current_mini_amp", amp[n])
	set("root:acqbrowser:abminis:current_mini_num", n)
	
end

Function SetVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName

	viewmini(varnum)

End

Function ButtonProc_2(ctrlName) : ButtonControl //killmini
	String ctrlName
	
	wave /t wn=root:minilist_wname
	wave tc=root:minilist_tcrossing
	wave rt=root:minilist_rt
	wave amp=root:minilist_amp
	
	variable n=get("root:curr_mini", 0)
	
	deletepoints n, 1, wn
	deletepoints n, 1, tc
	deletepoints n, 1, rt
	deletepoints n, 1, amp
	
	viewmini(n)	
	
End
