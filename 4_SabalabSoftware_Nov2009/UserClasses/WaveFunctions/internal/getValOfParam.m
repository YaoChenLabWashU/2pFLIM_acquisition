function varargout=getValOfParam(property_argin,param)
% Function accepts in a varargin (param/value) type cell array and a param
% to locate in that cell array.  It returns either just the value
% for one output or returns the updated cell array with all references to 
% the given param value pair removed.
% Redundancy is alos removed from the cell array.
% Now accepts in a cell array of params.

if nargin == 2
    if ~iscell(property_argin) | mod(length(property_argin),2) == 1
        error('getValOfParam: First input must be a cell array of param/val pairs');
    end
else
    error('getValOfParam: Requires 2 inputs.');
end

if ischar(param)
    param={param};
elseif ~iscellstr(param)
    error('getValOfParam: param must be a char or a cell array of chars.');
end

val={};
for paramCounter=param
    % Establish if param was passed and if it is correct.
    locationOfParam=strcmpi(property_argin,paramCounter{1});
    indicesOfParam=find(locationOfParam);
    if isempty(indicesOfParam)
        val=[val {[]}];
    else
        val=[val {property_argin{indicesOfParam(1)+1}}];
    end
    locationOfParam(indicesOfParam+1)=1;
    property_argin(locationOfParam)=[];  %delete the param/val pairs from the params to be parsed
end

%if only one param, do not pass out a cell array, pass out waht is in the cell array.
if length(val) == 1
    val=val{1};
end

if nargout==1
    varargout{1}=val;
elseif nargout==2
    varargout{1}=val;
    varargout{2}=property_argin;
else
    error('getValOfParam: Too many output arguments.');
end