function spc_drawLifetime(chan,fast)
% calculates the lifetime (above the LutLower and cropped to ROI) and displays it
% fast just avoids bringing the window to the front
% multiFLIM gy 2011116
global spc state gui

if nargin<2
    fast = 1;
end

if bitget(state.spc.FLIMchoices(chan),3)  % special channel
    % right now, no lifetime display for special channels
    return
end

nsPerPoint=spc.datainfo.psPerUnit/1000;
range = round([spc.fits{chan}.fitstart spc.fits{chan}.fitend]/nsPerPoint);

if (spc.switches.imagemode == 1)
    % get this channel's ROI information
    spc_roi=round(get(gui.spc.projects{chan}.roi, 'Position'));
%     if spc_roi(3) > spc.size(3) | spc_roi(4) > spc.size(2)
%         spc_selectAll;
%     end
%     if isfield(spc, 'roipoly')
%         if size(spc.roipoly) ~= spc.size(2:3)
%             spc_selectAll;
%         end
%     end

   try  % FIRST - select only the data with intensity>=LutLower
        % make a logical 2D matrix of the correct points
        if spc.SPCdata.line_compression >= 2
            ss = spc.SPCdata.line_compression;
            index = (spc.projects{chan} >= spc.switchess{chan}.LutLower);
            [yi, xi] = meshgrid(ss:ss:spc.SPCdata.scan_size_x*ss, ss:ss:spc.SPCdata.scan_size_y*ss);
            index = interp2(index, yi, xi, 'nearest');          
        else
            index = (spc.projects{chan} >= spc.switchess{chan}.LutLower);
        end
        % extend and shape this back to the 3D matrix required to select
        % from the raw lifetime data in imageMod
        siz = size(index);
        %bw = (spc.lifetimeMap > 1);
        %index =index.*bw;        siz = size(index);	
		index = repmat (index(:), [1,spc.size(1)]);
		index = reshape(index, siz(1), siz(2), spc.size(1));
		index = permute(index, [3,1,2]);

        imageMod = index .*  spc.imageMods{chan}; % reshape((spc.imageMod), spc.size(1), spc.SPCdata.scan_size_y, spc.SPCdata.scan_size_x);
        %spc.imageMod = image;
    catch
        %image = reshape(full(spc.imageMod), spc.size(1), spc.size(2), spc.size(3));
        imageMod = spc.imageMods{chan};
        disp('spc_drawlifetime: LUT error');
   end
    
    % This part selects using roipoly (seems obsolete to me gy 201111)
%     if isfield(spc, 'roipoly')
%         index = spc.roipoly{chan};
%         if spc.SPCdata.line_compression > 1 %Skip anyway)
%             aa = spc.SPCdata.line_compression;
%             [xi, yi] = meshgrid(aa:aa:spc.SPCdata.scan_size_x*aa, aa:aa:spc.SPCdata.scan_size_y*aa);
%             index = interp2(index, xi, yi, 'nearest');          
%         else
%             siz = size(index);
%             index = repmat (index(:), [1,spc.size(1)]);
%             index = reshape(index, siz(1), siz(2), spc.size(1));
%             index = permute(index, [3,1,2]);
%             try
%                 imageMod = reshape((index(:) .*  imageMod(:)), spc.size(1), spc.SPCdata.scan_size_y, spc.SPCdata.scan_size_x);
%             catch
%                 imageMod = spc.imageMods{chan};
%             end
%         end
%     else
%         imageMod = imageMod;
%     end
    
    % and finally, crop the image to the roi rectangle in the figure
    
    if spc.SPCdata.line_compression > 1
        spc_roi1 = round((spc_roi+spc.SPCdata.line_compression) / spc.SPCdata.line_compression);
    else
        spc_roi1 = spc_roi;
    end
    
    try
        % this line does the actual crop-to-ROI
        cropped = imageMod(:, spc_roi1(2):spc_roi1(2)+spc_roi1(4)-1, spc_roi1(1):spc_roi1(1)+spc_roi1(3)-1);
    catch
        disp('Cropping problem?');
        %spc_roi = [1, 1, spc.size(2), spc.size(3)];
        spc.size = size(spc.imageMods{chan});
        % reset to full size
        if spc.SPCdata.line_compression > 1
            spc_roi = [spc.SPCdata.line_compression, spc.SPCdata.line_compression, spc.SPCdata.scan_size_x*spc.SPCdata.line_compression, ...
                spc.SPCdata.scan_size_y*spc.SPCdata.line_compression]-spc.SPCdata.line_compression;
            spc_roi1 = round(spc_roi / spc.SPCdata.line_compression)-1;
        else
            spc_roi = [1,1,spc.SPCdata.scan_size_x, spc.SPCdata.scan_size_y];
            spc_roi1 = spc_roi;
        end
        spc_roi1(spc_roi1<1) = 1;
        % and reset the actual displayed roi and mapRoi to match
		set(gui.spc.projects{chan}.roi, 'Position', spc_roi);
        set(gui.spc.projects{chan}.mapRoi, 'position', spc_roi, 'EdgeColor', [1,1,1]);
        cropped = imageMod(:, spc_roi1(2):spc_roi1(2)+spc_roi1(4)-1, spc_roi1(1):spc_roi1(1)+spc_roi1(3)-1);
    end
    spc.lifetimes{chan} = reshape(sum(sum(cropped, 2),3), 1, spc.size(1));
end;

% GY - calculate and display the mean intensity in the main ROI
intensity = sum(spc.lifetimes{chan}) / (spc_roi1(3)*spc_roi1(4)); % photons/pixels
set(gui.spc.projects{chan}.ROImean,'String',['r0 = ' num2str(floor(intensity*10)/10,4)]);
 
% now get the 1D lifetime data restricted to the fit range
lifetime = spc.lifetimes{chan}(range(1):1:range(2));
lifetime = lifetime(:);
t = (range(1):range(2))*nsPerPoint;

% the plots for different channels are created in spc_drawInit
set(gui.spc.figure.lifetimePlot(chan), 'XData', t, 'YData', lifetime);
% gy 201112 don't make the fit look like the data
%set(gui.spc.figure.fitPlot(chan), 'XData', t, 'YData', lifetime);
%set(gui.spc.figure.residualPlot(chan), 'Xdata', t, 'Ydata', zeros(length(lifetime), 1));
set(gui.spc.figure.lifetimeAxes, 'XTick', []);
if (spc.switches.logscale == 0)
    set(gui.spc.figure.lifetimeAxes, 'YScale', 'linear');
else
    set(gui.spc.figure.lifetimeAxes, 'YScale', 'log');
end

% if not fast, bring the lifetime plot figure to the front
if ~fast
    figure(gui.spc.figure.lifetime);
end