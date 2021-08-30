function FLIM_FillParameters
% copies values from state.spc.acq.SPCdata{board} into GUI
% GY: added to avoid parameter passing
global state spc gh

handles=gh.spc.FLIM_Parameters;
% gy multiboard 201202
board=get(handles.figure1,'UserData');  % current module number for GUI stored here
% technically this is the module number + 1

% SPCdata.mode
if (state.spc.acq.SPCdata{board}.mode>=0)&&(state.spc.acq.SPCdata{board}.mode<=3)
    set(handles.popupmenu1,'Value',state.spc.acq.SPCdata{board}.mode+1);
else
    set(handles.popupmenu1,'String','???');
end
%set(handles.edit31,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.mode));

% SPCdata.stop_on_ovfl
switch state.spc.acq.SPCdata{board}.stop_on_ovfl
    case 0
        set(handles.edit22,'Value',0);
    case 1
        set(handles.edit22,'Value',1);
end
%set(handles.edit22,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.stop_on_ovfl));

% SPCdata.stop_on_time
switch state.spc.acq.SPCdata{board}.stop_on_time
    case 0
        set(handles.edit21,'Value',0);
    case 1
        set(handles.edit21,'Value',1);
end
%set(handles.edit21,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.stop_on_time));

% SPCdata.adc_resolution
switch state.spc.acq.SPCdata{board}.adc_resolution
    case 6
        set(handles.popupmenu2,'Value',1);
    case 8
        set(handles.popupmenu2,'Value',2);    
    case 10
        set(handles.popupmenu2,'Value',3);
    case 12
        set(handles.popupmenu2,'Value',4);
end
%set(handles.edit16,'String',sprintf('%i',state.spc.acq.SPCdata{board}.adc_resolution));

% SPCdata.dither_range
switch state.spc.acq.SPCdata{board}.dither_range
    case 0
        set(handles.popupmenu3,'Value',1);
    case 32
        set(handles.popupmenu3,'Value',2);
    case 64
        set(handles.popupmenu3,'Value',3);
    case 128
        set(handles.popupmenu3,'Value',4);
    case 256
        set(handles.popupmenu3,'Value',5);
end
%set(handles.edit23,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.dither_range));

% SPCdata.count_incr
set(handles.edit24,'String',sprintf('%i',state.spc.acq.SPCdata{board}.count_incr));
%set(handles.slider24,'Value',state.spc.acq.SPCdata{board}.count_incr);

% SPCdata.collect,repeat,display_time
set(handles.edit18,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.collect_time));
set(handles.edit20,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.repeat_time));
set(handles.edit19,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.display_time));

% SPCdata.dead_time_comp
switch state.spc.acq.SPCdata{board}.dead_time_comp
    case 0
        set(handles.edit26,'Value',0);
    case 1
        set(handles.edit26,'Value',1);
end
%set(handles.edit26,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.dead_time_comp));





%set(handles.edit1,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.base_adr));
%set(handles.edit2,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.init));
set(handles.edit3,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.cfd_limit_low-0.01));
%set(handles.edit4,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.cfd_limit_high));
set(handles.edit5,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.cfd_zc_level));
%set(handles.edit6,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.cfd_holdoff));
set(handles.edit7,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.sync_zc_level));
set(handles.edit8,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.sync_holdoff));
set(handles.edit9,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.sync_threshold));
set(handles.edit10,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.tac_range));
set(handles.edit11,'String',sprintf('%d',state.spc.acq.SPCdata{board}.sync_freq_div));
set(handles.edit12,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.tac_gain));
set(handles.edit13,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.tac_offset));
set(handles.edit14,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.tac_limit_low));
set(handles.edit15,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.tac_limit_high));
set(handles.edit17,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.ext_latch_delay));
%set(handles.edit25,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.mem_bank));
set(handles.edit27,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.scan_control));
set(handles.edit28,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.routing_mode));
set(handles.edit29,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.tac_enable_hold));
%set(handles.edit30,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.pci_card_no));
set(handles.edit32,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.test_eep));
set(handles.edit33,'String',sprintf('%d',state.spc.acq.SPCdata{board}.scan_size_x));
set(handles.edit34,'String',sprintf('%d',state.spc.acq.SPCdata{board}.scan_size_y));
set(handles.edit35,'String',sprintf('%d',state.spc.acq.SPCdata{board}.scan_rout_x));
set(handles.edit36,'String',sprintf('%d',state.spc.acq.SPCdata{board}.scan_rout_y));
set(handles.edit37,'String',sprintf('%d',state.spc.acq.SPCdata{board}.scan_polarity));
set(handles.edit38,'String',sprintf('%d',state.spc.acq.SPCdata{board}.scan_flyback));
set(handles.edit39,'String',sprintf('%d',state.spc.acq.SPCdata{board}.scan_borders));
set(handles.edit40,'String',sprintf('%d',state.spc.acq.SPCdata{board}.pixel_clock));
set(handles.edit41,'String',sprintf('%d',state.spc.acq.SPCdata{board}.line_compression));
set(handles.edit42,'String',sprintf('%d',state.spc.acq.SPCdata{board}.trigger));
set(handles.edit43,'String',sprintf('%.2f',state.spc.acq.SPCdata{board}.pixel_time*1e6));
set(handles.edit44,'String',sprintf('%d',state.spc.acq.SPCdata{board}.ext_pixclk_div));
set(handles.edit45,'String',sprintf('%d',state.spc.acq.SPCdata{board}.rate_count_time));
%set(handles.edit46,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.macro_time_clk));
set(handles.edit47,'String',sprintf('%d',state.spc.acq.SPCdata{board}.add_select));
%set(handles.edit48,'String',sprintf('%.10f',state.spc.acq.SPCdata{board}.adc_zoom));

