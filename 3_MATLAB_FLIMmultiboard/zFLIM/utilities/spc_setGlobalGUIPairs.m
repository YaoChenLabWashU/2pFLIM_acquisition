function spc_setGlobalGUIPairs(handles,defs)
% sets global-GUI pairs using UserData and storage of handle in a related global
% {'guiName','globalprefix',#locs,'globalField'[,window#forMultiWin]} 
% initial value of UserData can specify precision
for k=1:length(defs)
    def=defs{k};
    hObject=handles.(def{1});
    globalName=def{2};
    elements=def{3};
    fieldName=def{4};
    % a fifth parameter for this item means that there are multiple windows
    % and the multiple parameters correspond to multiple windows
    if numel(def)>4
        multiWindow=1;
        win=def{5};
    else
        multiWindow=0;
    end
    
    [topName structName fName]=structNameParts(globalName);
    eval(['global ' topName]);
   % now create the new subfield if necessary
    if isempty(def{3})
        % just a single object (subfield)
        if ~isfield(globalName,fieldName)
            eval([globalName '.' fieldName '=0;']);
        end
        elements=0;
    else
        % a multiple (cell array) object
        for j=1:elements
            elName=[globalName '{' num2str(j) '}'];
            if ~isfield(elName,fieldName)
                eval([elName '.' fieldName '=0;']);
            end
        end
    end
    % now set the UserData of the GUI object to link to variable
    % and set a GUIpair to link the variable to the object
    ud=get(hObject,'UserData');
    if ~isstruct(ud)
        % The original UserData (set in GUIDE) can be a single number
        % specifying the numeric precision for this control
        if numel(ud)==1 || isnumeric(ud)
            precision=ud;
            ud=[];
            ud.Precision=precision;
        else
            ud=[];
        end
    end
    ud.Multiple=elements; % this field specifies single (0) or multiple
    
    if elements==0
        % for a single, the Global field is simple
        % and the gui object handle is stored in GUIS.name one level up
        ud.Global=[globalName '.' fieldName];
        eval([globalName '.GUIS.' fieldName '=hObject;']);
    else
        % for a multiple, the Global and Field are stored
        % and the gui object handle is stored in GUI_structname
        ud.Global=globalName;
        ud.Field=fieldName;
        if multiWindow
            eval([structName '.GUI_' fName '.' fieldName '(' num2str(win) ')=hObject;']);
        else
            eval([structName '.GUI_' fName '.' fieldName '=hObject;']);
        end
    end
    set(hObject,'UserData',ud);
end
