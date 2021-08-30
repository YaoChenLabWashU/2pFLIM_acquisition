function spc_GUIchange(hObj,chan,handles)
% this is a callback function from objects that have changed value
global spc
if isempty(chan)
    chan=spc_mainChannelChoice;
end
style=get(hObj,'Style');

% Construct the name of the connected global variable
ud=get(hObj,'UserData');  % info about the related global
if isfield(ud,'Multiple') && ud.Multiple>=1
    varname=[ud.Global '{' num2str(chan) '}.' ud.Field];
else
    varname=[ud.Global '.' ud.Field];
end

% Get the value from the control
try
    if strcmp(style,'checkbox')
        value=get(hObj,'Value');
    else
        value=str2double(get(hObj,'String'));
    end
catch % if invalid value in the control, set it back to the global
    % don't need to worry about checkboxes
    try
        precision=ud.Precision;
    catch
        precision=3;
    end
    if isempty(precision) precision=3; end
    set(hObj,'String',num2str(eval(varname),precision));
    return
end

% do the assignment
eval([varname '=' num2str(value) ';']);