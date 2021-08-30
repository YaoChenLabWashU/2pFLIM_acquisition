#pragma rtGlobals=1		// Use modern global access method.

function strip_newline(s)
	string s
	variable i, imax
	imax=strlen(s)
	
	for(i=0;i<imax;i+=1)
		//if(s[i]=='\r')
			//s[i]=' '
		//endif
		//if(s[i]=='\n')
			//s[i]=' '
		//endif	
	endfor
	
	return(s)
end

function get(varname, defval)
	string varname
	variable defval
	
	if(cmpstr(stringfromlist(0, varname, ":"),"root")!=0)
		varname="root:"+varname
	endif

	return numvarordefault(varname, defval)
end

function set(varname, val)
	string varname
	variable val

	if(cmpstr(stringfromlist(0, varname, ":"),"root")!=0)
		varname="root:"+varname
	endif
	
	switch(exists(varname))
		case 2: //already existing
			nvar var_ref=$varname
			var_ref=val
			break
		case 0: // non-existant
			string pathstr=removefromlist(stringfromlist(ItemsInList( varname, ":")-1,  varname, ":"), varname, ":")
			ensureDataFolder(pathstr)
			variable /g $varName=val
			break
		default: // must be something else
			abort "set error"
			break
	endswitch
end

function /s gets(varname, defval)
	string varname
	string defval
	
	if(cmpstr(stringfromlist(0, varname, ":"),"root")!=0)
		varname="root:"+varname
	endif

	return strvarordefault(varname, defval)
end

function sets(varname, val)
	string varname
	string val

	varname=sanitizepath(varname)
	
	switch(exists(varname))
		case 2: //already existing
			svar var_ref=$varname
			var_ref=val
			break
		case 0: // non-existant
			string pathstr=removefromlist(stringfromlist(ItemsInList( varname, ":")-1,  varname, ":"), varname, ":")
			ensureDataFolder(pathstr)
			string /g $varName=val
			break
		default: // must be something else
			abort "set error"
			break
	endswitch
end

function setw(varname, val)
	string varname
	wave val

	if(cmpstr(stringfromlist(0, varname, ":"),"root")!=0)
		varname="root:"+varname
	endif
	
	switch(exists(varname))
		case 2: //already existing
			duplicate /o val $varname
			break
		case 0: // non-existant
			string pathstr=removefromlist(stringfromlist(ItemsInList( varname, ":")-1,  varname, ":"), varname, ":")
			ensureDataFolder(pathstr)
			duplicate /o val $varname
			break
		default: // must be something else
			abort "set error"
			break
	endswitch
end

function getw(varname, defn, def_dx)
	string varname
	variable defn
	variable def_dx

	if(cmpstr(stringfromlist(0, varname, ":"),"root")!=0)
		varname="root:"+varname
	endif
	
	if(exists(varname)!=1)
		neww(varname, defn, def_dx)
	endif
	
	wave w=$varname
	
	return w
end

function getw2(varname, defn, def_dx)
	string varname
	variable defn
	variable def_dx

	if(cmpstr(stringfromlist(0, varname, ":"),"root")!=0)
		varname="root:"+varname
	endif
	
	if(exists(varname)!=1)
		neww2(varname, defn, def_dx)
	endif
	
	wave w=$varname
	
	return w
end

function getw_or_set(varname, defn, def_dx, dims, val)
	string varname
	variable defn
	variable def_dx
	variable dims
	variable val

	if(cmpstr(stringfromlist(0, varname, ":"),"root")!=0)
		varname="root:"+varname
	endif
	
	if(exists(varname)!=1)
		if(dims==1)
			neww(varname, defn, def_dx)
		else
			neww2(varname, defn, def_dx)
		endif	
		wave w=$varname
		w=val	
	else
		wave w=$varname
	endif

	return w
end

function neww(varname, defn, def_dx)
	string varname
	variable defn
	variable def_dx
	if(cmpstr(stringfromlist(0, varname, ":"),"root")!=0)
		varname="root:"+varname
	endif
	
	string pathstr=removefromlist(stringfromlist(ItemsInList( varname, ":")-1,  varname, ":"), varname, ":")
	ensureDataFolder(pathstr)
	
	make/o/n=(defn) $varname
	setscale /p x, 0, def_dx, $varname
	//wave w=$varname
	//w=nan
end


function neww2(varname, defn, def_dx)
	string varname
	variable defn
	variable def_dx
	if(cmpstr(stringfromlist(0, varname, ":"),"root")!=0)
		varname="root:"+varname
	endif
	
	string pathstr=removefromlist(stringfromlist(ItemsInList( varname, ":")-1,  varname, ":"), varname, ":")
	ensureDataFolder(pathstr)
	
	make/o/n=(defn, defn) $varname
	setscale /p x, 0, def_dx, $varname
	setscale /p y, 0, def_dx, $varname
end


function EnsureDataFolder(varpath)
	string varpath
	variable num    
	
	if(cmpstr(stringfromlist(0, varpath, ":"),"root")!=0)
		varpath="root:"+varpath
	endif

	
	variable numitems=ItemsInList(varpath, ":")
	
	variable i, j
	string tempstr
	
	for(i=1;i<numitems; i+=1)
		//print i, stringfromlist(i, varpath, ":")
		tempstr="root:"
		for(j=1;j<=i;j+=1)
			tempstr=tempstr+stringfromlist(j, varpath, ":")+":"
		endfor
		
		tempstr=tempstr[0,strlen(tempstr)-2] //remove trailing :
		
		if(!datafolderexists(tempstr))
			//print i, tempstr
			if(exists(tempstr)==0)
				execute "newdatafolder "+tempstr
			else
				abort "name conflict: "+tempstr
			endif
		endif
	endfor
end

function ensureVar(varname, defval)
	string varname
	variable defval

	varname=sanitizepath(varname)
	
	switch(exists(varname))
		case 2:
			break
		case 0: // non-existant
			string pathstr=removefromlist(stringfromlist(ItemsInList( varname, ":")-1,  varname, ":"), varname, ":")
			ensureDataFolder(pathstr)
			variable /g $varname=defval
			break
		default:
			abort "naming error"
			break
		endswitch
end

function killByName(s)
string s
string list=wavelist(s+"*", ";",  "")
variable i=0
	//print list 
	string wn
	do
		wn=stringfromlist(i, list, ";")
		if (strlen(wn)>0)
			killwaves/z $wn
		endif
		i+=1
	while (strlen(wn)>0)
end



function nanByName(s)
string s
string list=wavelist(s+"*", ";",  "")
variable i=0
	
	string wn
	do
		wn=stringfromlist(i, list, ";")
		if (strlen(wn)>0)
			wave w=$wn
			w=nan
			Note/k w
		endif
		i+=1
	while (strlen(wn)>0)
end

function zeroToNan(x)
	variable x
	if(x==0)
		return Nan
	else
		return x
	endif
end

function ZeroByName(s)
string s
string list=wavelist(s+"*", ";",  "")
variable i=0
	
	string wn
	do
		wn=stringfromlist(i, list, ";")
		if (strlen(wn)>0)
			wave w=$wn
			w=0
			Note/k w
		endif
		i+=1
	while (strlen(wn)>0)
end

function countByName(s)
string s
return itemsinlist(wavelist(s+"*", ";",  ""))
end

function ScaleByList(list, delta)
string list
variable delta
variable i=0
	
	string wn
	do
		wn=stringfromlist(i, list, ";")
		if (strlen(wn)>0)
			wave w=$wn
			SetScale/P x 0,delta,"", w
		endif
		i+=1
	while (strlen(wn)>0)
end

function/s num3str(val)
variable val
string s=""

if(val<10)
	sprintf s, "00%d", val
else 
	if(val<100)
		sprintf s, "0%d", val
	else
		s=num2istr(val)
	endif
endif

return s

end


function moveWavesToFolder(wlist, foldername)
	string wlist
	string foldername
	
	if(cmpstr(stringfromlist(0, foldername, ":"),"root")!=0)
		foldername="root:"+foldername
	endif

	ensureDataFolder(foldername)
	
	variable i=0
	
	string wn
	do
		wn=stringfromlist(i, wlist, ";")
		if (strlen(wn)>0)
			wave w=$wn
			duplicate /o w $foldername+":"+wn
			killwaves /z w
		endif
		i+=1
	while (strlen(wn)>0)

end

Function exp_xshift(w,x) : FitFunc
	Wave w
	Variable x

	//CurveFitDialog/ These comments were created by the Curve Fitting dialog. Altering them will
	//CurveFitDialog/ make the function less convenient to work with in the Curve Fitting dialog.
	//CurveFitDialog/ Equation:
	//CurveFitDialog/ f(x) = amp*((x-x0)/tau)+y0
	//CurveFitDialog/ End of Equation
	//CurveFitDialog/ Independent Variables 1
	//CurveFitDialog/ x
	//CurveFitDialog/ Coefficients 4
	//CurveFitDialog/ w[0] = tau
	//CurveFitDialog/ w[1] = x0
	//CurveFitDialog/ w[2] = amp
	//CurveFitDialog/ w[3] = y0
	
	if(x<w[1])
		return w[3]
	else
		return w[2]*exp(-(x-w[1])/w[0])+w[3]
	endif
End


function get_f_peak(wname)

	string wname
	
	wave w=$wname

	Make/D/N=4/O W_coef
	W_coef[0] = {30,53,1.6,1}
	FuncFit /q/w=0 exp_xshift W_coef  w[5,124] /D 

	//print wname, w_coef[2]
	return w_coef[2]

end

function allpeaks()
string wl=wavelist("*", ";", "WIN:")
	variable i=0

	do

		string wn=stringfromlist(i, wl ,";")
		if (exists(wn))
			if(cmpstr("fit_", wn[0,3])!=0)
				print wn, get_f_peak(wn)
			endif	
		endif

		i+=1
	while (strlen(wn)>0)
end


function /s SanitizePath(vname)
	string vname
	if(cmpstr(stringfromlist(0, vname, ":"),"root")!=0)
		vname="root:"+vname
	endif
	
	string pathstr=removefromlist(stringfromlist(ItemsInList( vname, ":")-1,  vname, ":"), vname, ":")
	ensureDataFolder(pathstr)
	
	return vname
end

function bl_sub(from, to)
	variable from
	variable to
	String savedDF= GetDataFolder(1)
		
	setDataFolder root:state:avg
	string execstr="wavestats/q/r=("+num2str(from)+", "+num2str(to)+") %s;%s-=v_avg"
	applytowin(execstr)
	SetDataFolder savedDF
end

function elong(w, val)
	wave w
	variable val
	
	variable n=numpnts(w)
	redimension /n=(n+1) w
	w[n]=val

end

function AppendVal(wname, val)
	string wname
	variable val
	
	wname=SanitizePath(wname)
	
	
	wave w=$wname
	if(waveexists(w))
		redimension/n=(numpnts(w)+1) w
	else
		make/o/n=1 $wname
		wave w=$wname
	endif
	
	w[numpnts(w)-1]=val
end

function AppendTextVal(wname, tval)
	string wname
	string tval
	
	wname=SanitizePath(wname)
	
	
	wave /t w=$wname
	if(waveexists(w))
		redimension/n=(numpnts(w)+1) w
	else
		make/t/o/n=1 $wname
		wave/t w=$wname
	endif
	
	w[numpnts(w)-1]=tval
end

function getLinesFromNotebook(nb, str)
string nb
string str
make/o/t/n=0 nbLines
notebook $nb selection={startOfFile, startOfFile}

do
	notebook $nb findText={str, 0}
	if(V_flag)
		notebook $nb selection={startOfParagraph, endOfParagraph}
		getselection notebook, $nb, 2
		//svar s_selection
		//print s_selection
		AppendTextVal("nbLines", s_selection[0,strlen(s_selection)-2])
	endif
while(V_flag)

end