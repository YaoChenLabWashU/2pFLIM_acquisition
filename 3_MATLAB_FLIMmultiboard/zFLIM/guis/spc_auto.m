function spc_auto(flag, page);
disp('spc_auto NEEDS WORK');
return

global spc;
global state;
global gui;

% if get(gui.spc.spc_main.selectAll, 'Value')
%     spc_selectAll;
% end
if nargin == 0
    flag = 0;
end
if nargin < 2
    page = 0;
end

pos_max2 = str2num(get(gui.spc.spc_main.F_offset, 'String'));
if pos_max2 == 0 | isnan (pos_max2)
    pos_max2 = spc.datainfo.psPerUnit/1000; %GY modified from 1.0
end
if max(spc.lifetime) <= 0
    return;
end
if ~page
    %spc_updateMainStrings;
end


name_start=findstr(spc.filename, '\');
name_start=name_start(end)+1;

if strfind(spc.filename, 'max')
    baseName_end=length(spc.filename)-11;
elseif strfind(spc.filename, 'glu')
    baseName_end=length(spc.filename)-11;
else
    baseName_end=length(spc.filename)-7;
end
baseName=spc.filename(name_start:baseName_end);
graph_savePath=spc.filename(1:name_start-5);
spc_savePath=spc.filename(1:name_start-1);

eval(['global  ', baseName]);
cd (spc_savePath);

if exist([baseName, '.mat'])
    load([baseName, '.mat'], baseName);
    evalc(['a = ', baseName]);
    try
        str1 = a.textbox;
    catch
        str1 = '';
    end
else
    str1 = '';
    %disp('no such file');
    %button = questdlg('Do you want to make new files?');
    %return;
end

if get(gui.spc.spc_main.fit_eachtime, 'Value')
    try % altered by GY 201012 to use stored lastFitFunction
        if isfield(spc.fit,'lastFitFunction')
            % use the last fit function
            fh=str2func(spc.fit.lastFitFunction);
            fh();
        else spc_fitexp2gaussGY;
        end
        fit_error = 0;
    catch
        fit_error = 1;
    end
else
    fit_error = 1;
end

if isfield(spc.fit, 'beta0')
    p1 = spc.fit.beta0(1);
    p2 = spc.fit.beta0(3);
    tau1 = spc.fit.beta0(2)*spc.datainfo.psPerUnit/1000;
    tau2 = spc.fit.beta0(4)*spc.datainfo.psPerUnit/1000;
    f = p2/(p1+p2);
else
    return;
end
        
spc_dispbeta;
evalc(['a = ', baseName]);

try
    a.textbox = get(gui.spc.textbox, 'String');
end

if flag == 0
    fc = state.files.fileCounter;
else
    fc = str2num(spc.filename(baseName_end+1:baseName_end+3));
end
try
    if ~isfield(a, 'tau_m2')
        a.tau_m2(length(a.fraction)) = 0;
    end
    if isempty(a.tau_m2)
        a.tau_m2(length(a.fraction)) = 0;
    end
end

a.fraction(fc) = f;
a.tau1(fc) = tau1;
a.tau2(fc) = tau2;

%a.tau_m(fc) = sum(spc.lifetime)/max(spc.lifetime)*spc.datainfo.psPerUnit/1000;
range = spc.fit.range;
t1 = (1:range(2)-range(1)+1); t1 = t1(:);
lifetime = spc.lifetime(range(1):range(2)); lifetime = lifetime(:);
if sum(lifetime(:)) <= 0
    return;
end
a.tau_m(fc) = (tau1*tau1*(1-f) + tau2*tau2*f)/(tau1*(1-f) + tau2*f);
a.tau_m2(fc) = sum(lifetime.*t1)/sum(lifetime)*spc.datainfo.psPerUnit/1000 - pos_max2;
if ~isfield(a, 'time2')
    try
        a.time2 = a.time;
    end
end
if ~isfield(a, 'time3')
    try
        a.time3 = a.time;
    end
end
a.time(fc) = datenum([spc.datainfo.date, ',', spc.datainfo.time]);
% if ~isempty(spc.scanHeader.internal.triggerTimeString)
%     a.time2(fc) = datenum(spc.scanHeader.internal.triggerTimeString);
% end GY (didn't exist)
a.time3(fc) = datenum(spc.datainfo.triggerTime);

tauD = spc.fit.beta0(2)*spc.datainfo.psPerUnit/1000;
tauAD = spc.fit.beta0(4)*spc.datainfo.psPerUnit/1000;
if ~isfield(a, 'fraction2')
    a.fraction2 = 0*a.fraction; %%% for backword compatibility
end
a.fraction2(fc) = tauD*(tauD-a.tau_m2(fc))/(tauD-tauAD) / (tauD + tauAD -a.tau_m2(fc));
a.time(a.time<7.3e5) = a.time(fc);
a.time3(a.time3<7.3e5) = a.time3(fc);

a.fraction(a.fraction > 1) = 1;
a.fraction(a.fraction < -0.1) = -0.1;
a.fraction2(a.fraction2 > 1) = 1;
a.fraction2(a.fraction2 < -0.1) = -0.1;

if flag == 0
    a.time(state.files.fileCounter) = datenum(now);
end
%a.time = a.time - min (a.time);

% if isfield(spc.scanHeader.motor, 'position')
%     a.position(length(a.fraction)) = spc.scanHeader.motor.position;
% else    
%     a.position(length(a.fraction)) = state.motor.position;
%     spc.scanHeader.motor.position = state.motor.position;
% end GY-didn't exist
a.position(length(a.fraction))=0; % GY

eval([baseName, '= a;']);
save([spc_savePath, baseName, '.mat'], baseName);

if page
    return;
end
graphfile = [graph_savePath, baseName, '_tau_all.fig'];

if isfield(gui.spc, 'online')
     if ishandle(gui.spc.online)
        if strcmp(get(gui.spc.online, 'Tag'), 'Online_fig')
             fname_graph = get(gui.spc.online, 'filename');
             [G_pathstr,G_name,G_ext,G_versn] = fileparts(fname_graph);
             if strcmp(G_name, [baseName, '_tau_all'])
                saveas(gui.spc.online, graphfile);
             end
             %close(gui.spc.online);
        else
             mkfigure (str1, page);
        end
     else
         mkfigure(str1, page);
     end
 else
      mkfigure (str1, page);
end
 
figure (gui.spc.online);
    subplot(2,3,3);
    cstr = {'black', 'red', 'blue', 'green', 'magenta', 'cyan', 'black'};
    fl1 = 0;
    for pos = 0:max(a.position(:))
        ptime = (a.time3(a.position == pos)- min(a.time3))*60*24 ;
        pfrac = a.fraction(a.position == pos);
        if length(ptime) > 0
            pos = mod(pos, 7)+1;
            state.spc.autoPlot(pos+1) = plot(ptime, pfrac, '-o', 'Color', cstr{pos});
            if fl1 == 0; hold on; fl1 = 1; end
        end
    end
    hold off;
   ylabel('Fraction (tau2): Fitting'); 
   xlabel ('Time (min)');

    subplot(2,3,[1,2]);
    fl1 = 0;
    
    for pos = 0:max(a.position(:))
        ptime = (a.time3(a.position == pos)- min(a.time3))*60*24 ;
        pfrac2 = a.fraction2(a.position == pos);
        if length(ptime) > 0
            pos = mod(pos, 7)+1;
            state.spc.autoPlot_t(pos+1) = plot(ptime, pfrac2, '-o', 'Color', cstr{pos});
            if fl1 == 0; hold on; fl1 = 1; end
        end
    end
    hold off;
ylabel('Fraction (tau2)');
xlabel ('Time (min)');

subplot(2,3,[4,5]);
    fl1 = 0;
    for pos = 0:max(a.position(:))
        ptime = (a.time3(a.position == pos)- min(a.time3))*60*24 ;
        ptau = a.tau_m2(a.position == pos);
        ptau(ptau < 0.1) = 2;
        if length(ptime) > 0
            pos = mod(pos, 7)+1;
            state.spc.autoPlot_t(pos+1) = plot(ptime, ptau, '-o', 'Color', cstr{pos});
            if fl1 == 0; hold on; fl1 = 1; end
        end
    end
    hold off;
ylabel('mean photon emission time');
xlabel ('Time (min)');


if isfield(state, 'acq')
	if state.acq.linescan
		ydata_line1 = mean(state.acq.acquiredData{1}, 2);
        ydata_line2 = mean(state.acq.acquiredData{2}, 2);
        ydata_line1 = ydata_line1 - mean(ydata_line1(1:20));
        ydata_line2 = ydata_line2 - mean(ydata_line2(1:20));
        ydata_line3 = 100*spc_calcLinescan;
        xdata_line = 1:length(ydata_line1);
		try
            get(state.spc.autoPlot_line, 'XData');
            set(state.spc.autoPlot_line, 'XData', xdata_line, 'YData', ydata_line1, 'color', 'green');
            set(state.spc.autoPlot_line2, 'XData', xdata_line, 'YData', ydata_line2, 'color', 'red');
            set(state.spc.autoPlot_line3, 'XData', xdata_line, 'YData', ydata_line3, 'color', 'black');       
		catch
            figure(109);
            hold off;
            state.spc.autoPlot_line = plot(xdata_line, ydata_line1, 'color', 'green');
            hold on;
            state.spc.autoPlot_line2 = plot(xdata_line, ydata_line2, 'color', 'red');
            state.spc.autoPlot_line3 = plot(xdata_line, ydata_line3, 'color', 'black');
		end
        evalc([baseName, '_lines.a', num2str(state.files.fileCounter - 1), ' = ydata_line1']);
        evalc([baseName, '_lines.b', num2str(state.files.fileCounter - 1), ' = ydata_line2']);
        evalc([baseName, '_lines.c', num2str(state.files.fileCounter - 1), ' = ydata_line3']);      
        save([graph_savePath, baseName, '_lines.mat'], [baseName, '_lines']);
	end
end

% if length(a.time3) > length(a.fraction)
%     a.time3 = a.time(1:end-1)
% end


%ylim([0, 0.5])

%saveas(gui.spc.online, graphfile);

if isfield(state, 'acq')
    try
        save_autoSetting;
    catch
        disp('Error in saving Autosetting');
    end
end


function mkfigure (str1, page);
global gui;
if page
    return;
end
    gui.spc.online = figure;
    gui.spc.textbox = uicontrol('Style', 'edit', 'Unit', 'Normalized', ...
      'Position',[0.6607 0.1167 0.2893 0.3357], 'Max', 100, 'Min', 1, 'String', str1);
    set(gui.spc.online, 'Tag', 'Online_fig', 'CloseRequestFcn', 'spc_autoSave');
    set(gui.spc.textbox, 'BackgroundColor', 'White');
    set(gui.spc.textbox, 'HorizontalAlignment', 'left')