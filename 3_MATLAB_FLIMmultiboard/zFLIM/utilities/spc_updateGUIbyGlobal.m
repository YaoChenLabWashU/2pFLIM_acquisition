function spc_updateGUIbyGlobal(varargin)
% updates ('spc.fits',chan,'field') or ('spc.field')
% uses the spc.fits{setNum} and spc.switchess{setNum} to fill the GUI
[topName, structName, fieldName]=structNameParts(varargin{1});
eval(['global ' topName]);
if nargin==3
   fchan=varargin{2};
   fName=varargin{3};
   vName=[varargin{1} '{' num2str(varargin{2}) '}.' fName];
   GUIstorage=[topName '.GUI_' fieldName];
   hObj=eval([GUIstorage '.' fName]);
   if numel(hObj)>1
       % multiWindow (different window for each fChan)
       hObj=hObj(fchan);
   else
       % not multiWindow, but multi-valued, so only display if
       % channel matches the currently displayed choice
       if fchan~=spc_mainChannelChoice
           % we could make this more general by including the name of
           % a calculating function (like spc_mainChannelChoice)
           % in UserData
           return
       end
   end
else % single reference only
    vName=varargin{1};
    GUIstorage=[structName '.GUIS'];
    hObj=eval([GUIstorage '.' fieldName]);
end
if strcmp(get(hObj,'Style'),'checkbox')
    set(hObj,'Value',eval(vName));
else
    ud=get(hObj,'UserData');
    if isfield(ud,'Precision')
        precision=ud.Precision;
        if isempty(precision) || precision==0
            precision=3;
        end
    else
        precision=3;
    end
    set(hObj,'String',num2str(eval(vName),precision));
end
