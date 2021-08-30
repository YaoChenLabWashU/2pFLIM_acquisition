function funcName=spc_fitFuncName(lastFunc,order)
if findstr(lastFunc,'gauss')
    type='gauss';
elseif findstr(lastFunc,'triple')
    type='triple';
else
    type='prf';
end
switch type
    case 'prf'
        if order==1
            funcName='spc_fitexpprfGY';
        else
            funcName='spc_fitexp2prfGY';
        end
    case 'gauss'
        if order==1
            funcName='spc_fitexpgaussGY';
        else
            funcName='spc_fitexp2gaussGY';
        end
    case 'triple'
         if order==1
            funcName='spc_fitWithSingleExp_triple';
        else
            funcName='spc_fitWithDoubleExp_triple';
         end
end
       