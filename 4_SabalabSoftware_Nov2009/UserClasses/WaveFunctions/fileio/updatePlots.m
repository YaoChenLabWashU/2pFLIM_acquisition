function updatePlots(figureHandle)
% Thsi function will get called whenever the wv.scale or
% the wv.data is changed, to logically update all the plots the wave is tied to.
% the function looks at the userData in the plot under USerData.name = {'' 'wv' ''}
% and determiines where this wave name is (XDATA, YDATA, IMAGE)
% and parses accordingly.

if nargin<1
	figureHandle=gcf;
end

if ~ishandle(figureHandle)
	error('updatePlots : expect figure handle as argument');
end

handles = [findobj(figureHandle, 'Type', 'line'); findobj(figureHandle, 'Type', 'image')];	% Get all plots

for handleCounter = 1:length(handles)   % page through the handles
	if ishandle(handles(handleCounter))
		userdata = get(handles(handleCounter), 'UserData'); % look at plot userdata
		if isfield(userdata, 'name')   % does field exist in plot...
			xData=[];
			yData=[];
			zData=[];
			if ~isempty(userdata.name{1})	% xwave specified
				xData=evalin('base', [userdata.name{1} '.data']);
				if isempty(userdata.name{2})	% It's a reverse plot
					yData=makeXData(userdata.name{1});
				end	
			end
			
			if ~isempty(userdata.name{2})   % Y wave specified
				yData=evalin('base', [userdata.name{2} '.data']);
				if isempty(userdata.name{1})	% need to get the X data too
					xData=makeXData(userdata.name{2});
				end
			end
			
			isImagePlot=0;
			if ~isempty(userdata.name{3})	% there's a z wave
				isImagePlot=1;
				if isempty(userdata.name{1})
					xData=makeXData(userdata.name{3});
				end
				if isempty(userdata.name{2})
					yData=makeYData(userdata.name{3});
				end
				zData=evalin('base', [userdata.name{3} '.data']);
			end
			
			if size(xData,1)>1
				xData=xData(1,:);
			end
			if size(yData,1)>1
				yData=yData(1,:);
			end
			
			if ~isImagePlot
				len=min(length(xData), length(yData));
				if len==0	%BSMOD added below
					yData=nan;
					xData=nan;
				end
				set(handles(handleCounter), 'YData', yData(1:len), 'XData', xData(1:len));
				rescaleAxis(get(handles(handleCounter), 'Parent'));
			else
				lenx=min(length(xData), size(zData,2));
				leny=min(length(yData), size(zData,1));
				if lenx==0 & leny==0	%BSMOD added below
					yData=nan;
					xData=nan;
					zData=nan;
				elseif lenx==0
					xData=nan;
					zData=repmat(leny, 1, nan);
				elseif leny==0
					yData=nan;
					zData=repmat(1, lenx, nan);
				end					
				set(handles(handleCounter), 'CData', zData(1:leny, 1:lenx), 'XData', xData(1:lenx), 'YData', yData(1:leny));
				if leny==1
					set(handles(handleCounter), 'YData', [yData yData]);
				end
				if lenx==1
					set(handles(handleCounter), 'YData', [xData xData]);
				end
				rescaleAxis(get(handles(handleCounter), 'Parent'));
			end						
		end
		
	end
end
