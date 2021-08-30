function varargout=imagesc(in,varargin)
% Overloaded method for class char where the input is a
% string wave name.
% calls base class cell object
% new image function
% does not set colormap.  use imagesc.

if mod(nargin,2)==0	%Even inputs......so maybve wanting normal call to image...
	if any(strcmpi(in,imageProps))
		h=imagesc;
        varargin=[{in} varargin];
        set(h,varargin{:});
	else
		error('@char/imagesc: wrong number of inputs to image');
	end
else
	h=imagesc({in},varargin{:});
end

if nargout==1
    varargout{1}=h;
end

function out=imageProps
out={ 'AlphaData'
    'AlphaDataMapping'
    'BeingDeleted'
    'BusyAction'
    'ButtonDownFcn'
    'CData'
    'CDataMapping'
    'Children'
    'Clipping'
    'CreateFcn'
    'DeleteFcn'
    'EraseMode'
    'HandleVisibility'
    'HitTest'
    'Interruptible'
    'Parent'
    'Selected'
    'SelectionHighlight'
    'Tag'
    'Type'
    'UIContextMenu'
    'UserData'
    'Visible'
    'XData'
    'YData'};