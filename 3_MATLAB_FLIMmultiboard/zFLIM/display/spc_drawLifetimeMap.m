function spc_drawLifetimeMap (chan, flag, fast)
% flag forces recalc (populN-map always recalc'ed)
global spc;
global gui;
global state;

if spc.switches.imagemode == 0 
    return;
end;

calcPop = spc.switchess{chan}.drawPopulation;

range(1) = spc.switchess{chan}.lifeLimitLower; %str2num(get(gui.spc.figure.lifetimeUpperlimit, 'String'));
range(2) = spc.switchess{chan}.lifeLimitUpper; %str2num(get(gui.spc.figure.lifetimeLowerlimit, 'String'));
LUTrange(1) = spc.switchess{chan}.LutLower; %str2num(get(gui.spc.figure.LutUpperlimit, 'String'));
LUTrange(2) = spc.switchess{chan}.LutUpper; %str2num(get(gui.spc.figure.LutLowerlimit, 'String'));

% validate
% if (LUTrange(1) >= 0 & LUTrange(2) >= 0) & LUTrange(2) > LUTrange(1)
%     spc.switches.lutlim = LUTrange;
% else
%     set(gui.spc.figure.LutUpperlimit, 'String', num2str(spc.switches.lutlim(1)));
%     set(gui.spc.figure.LutLowerlimit, 'String', num2str(spc.switches.lutlim(2)));
% end

% redispatch if 'Draw Population' is selected
if calcPop
    if range(1) <= 1 && range(2) <= 1
        popLimit = range;
    else
        popLimit = [1,0];
    end
    if spc.fits{chan}.fixtau1 && spc.fits{chan}.fixtau2
        spc.rgbLifetimes{chan} = spc_drawPopulation (popLimit,chan);
    else
        errordlg ('Fix tau1 and tau2, and then press Auto!');
        % set(gui.spc.spc_main.pop_check, 'Value', 0);
        return;
    end
else
%     if range(1) > 1 | range(2) > 1
%         spc.switchess{chan}.lifetime_limit = range;
%     end    
    if nargin == 1  || flag == 1  % if flag=1 or not specified, recalc
        spc_calcLifetimeMap(chan);
    end
    spc_makeRGBLifetimeMap(chan);
end
    
if 0 % gy 201111 - save the trouble of rewriting all the ROIs %~fast
    spc_roi = get(gui.spc.projects{chan}.roi, 'Position');
    axes(gui.spc.lifetimeMaps{chan}.axes);
	lifetimeMap_context = uicontextmenu;
	gui.spc.lifetimeMaps{chan}.image = image(spc.rgbLifetimes{chan}, 'UIContextMenu', lifetimeMap_context);
	set(gui.spc.lifetimeMaps{chan}.axes, 'XTick', [], 'YTick', []);
	%item1 = uimenu(lifetimeMap_context, 'Label', 'Range...', 'Callback', 'spc_rangeDlog');
	%item2 = uimenu(lifetimeMap_context, 'Label', 'Restrict in roi', 'Callback', ['spc_selectRoi(' num2str(chan) ')']);
	
	%Roi!
	gui.spc.figure.mapRoi = rectangle('position', spc_roi, 'ButtonDownFcn', 'spc_dragRoi', 'EdgeColor', [1,1,1]);
else
    set(gui.spc.lifetimeMaps{chan}.image, 'CData', spc.rgbLifetimes{chan});
end


%redraw colormap.
%axes(gui.spc.figure.lifetimeMapColorbar);
%scale = 56:-1:9;
%scale = 9:56;
%image(scale(:));
%colormap(jet);
%set(gui.spc.lifetimeMaps{chan}.colorbar, 'XTickLabel', []);

% if drawing population, reset the upper and lower limits to those used
if calcPop
    spc.switchess{chan}.lifeLimitLower = popLimit(1);
    spc.switchess{chan}.lifeLimitUpper = popLimit(2);
    spc_updateGUIbyGlobal('spc.switchess',chan,'lifeLimitLower');
    spc_updateGUIbyGlobal('spc.switchess',chan,'lifeLimitUpper');
else % seems unnecessary here
    % range = [spc.switchess{chan}.lifeLimitLower spc.switchess{chan}.lifeLimitUpper]; 
end

