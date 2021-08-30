function varargout=plot(in,varargin)
% Overloaded method for class char where the input is a
% string wave name

if mod(nargin,2)==0	%Even inputs......so maybve wanting normal call to plot...
	if any(strcmpi(in,plotProps))
		h=plot;
        varargin=[{in} varargin];
        set(h,varargin{:});
	else
		error('@char/plot: wrong number of inputs to image');
	end
else
	h=plot({in},varargin{:});
end

if nargout==1
    varargout{1}=h;
end

function out=plotProps
out={ 'BeingDeleted'
    'BusyAction'
    'ButtonDownFcn'
    'Children'
    'Clipping'
    'Color'
    'CreateFcn'
    'DeleteFcn'
    'EraseMode'
    'HandleVisibility'
    'HitTest'
    'Interruptible'
    'LineStyle'
    'LineWidth'
    'Marker'
    'MarkerEdgeColor'
    'MarkerFaceColor'
    'MarkerSize'
    'Parent'
    'Selected'
    'SelectionHighlight'
    'Tag'
    'Type'
    'UIContextMenu'
    'UserData'
    'Visible'
    'XData'
    'YData'
    'ZData'};
