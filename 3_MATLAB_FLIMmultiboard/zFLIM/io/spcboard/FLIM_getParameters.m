function FLIM_getParameters(module)
% mod GY 201008:  now store only in state.spc.acq.SPCdata
% mod GY 201202:  multiboard store in state.spc.acq.SPCdata{m+1}
global state;


data=libstruct('s_SPCdata');
data.base_adr=0;
[out1 SPCdata]=calllib('spcm32','SPC_get_parameters',module,data);


if (out1~=0)
    error = FLIM_get_error_string (out1);    
    disp(['error during getting parameters:', error]);
else
    state.spc.acq.SPCdata{module+1}=SPCdata;
end

% if nargin
% 	handles.SPCdata=state.spc.acq.SPCdata;
% 	guidata(hObject,handles);
% end
% 
% if nargout && nargin
%     result = handles;
% end
