function FLIM_SaveParameters(handles)
% copies GUI values to state.spc.acq.SPCdata{board}
%  then sets to board, reads back from board, and refills GUI
% gy multiboard 201202 get current module from UserData
% NB this is technically the module number + 1

global state
board = get(handles.figure1,'UserData');

% SPCdata.mode
state.spc.acq.SPCdata{board}.mode=get(handles.popupmenu1,'Value')-1;
%state.spc.acq.SPCdata{board}.mode=str2num(get(handles.edit31,'String'));

% SPCdata.stop_on_ovfl
state.spc.acq.SPCdata{board}.stop_on_ovfl=get(handles.edit22,'Value');
%state.spc.acq.SPCdata{board}.stop_on_ovfl=str2num(get(handles.edit22,'String'));

% SPCdata.stop_on_time
state.spc.acq.SPCdata{board}.stop_on_time=get(handles.edit21,'Value');
%state.spc.acq.SPCdata{board}.stop_on_time=str2num(get(handles.edit21,'String'));

% SPCdata.adc_resolution
switch get(handles.popupmenu2,'Value')
    case 1
        state.spc.acq.SPCdata{board}.adc_resolution=6;
    case 2
        state.spc.acq.SPCdata{board}.adc_resolution=8;
    case 3
        state.spc.acq.SPCdata{board}.adc_resolution=10;
    case 4
        state.spc.acq.SPCdata{board}.adc_resolution=12;
    case 5
        state.spc.acq.SPCdata{board}.adc_resolution=0;
    case 6
        state.spc.acq.SPCdata{board}.adc_resolution=2;
    case 7
        state.spc.acq.SPCdata{board}.adc_resolution=4;
end

%state.spc.acq.resolution = state.spc.acq.SPCdata{board}.adc_resolution;

%state.spc.acq.SPCdata{board}.adc_resolution=str2num(get(handles.edit16,'String'));

% SPCdata.dither_range
switch get(handles.popupmenu3,'Value')
    case 1
        state.spc.acq.SPCdata{board}.dither_range=0;
    case 2
        state.spc.acq.SPCdata{board}.dither_range=32;
    case 3
        state.spc.acq.SPCdata{board}.dither_range=64;
    case 4
        state.spc.acq.SPCdata{board}.dither_range=128;
    case 5
        state.spc.acq.SPCdata{board}.dither_range=256;
end
%state.spc.acq.SPCdata{board}.dither_range=str2num(get(handles.edit23,'String'));

% SPCdata.count_incr
state.spc.acq.SPCdata{board}.count_incr=str2num(get(handles.edit24,'String'));

% SPCdata.collect,repeat,display_time
state.spc.acq.SPCdata{board}.collect_time=str2num(get(handles.edit18,'String'));
state.spc.acq.SPCdata{board}.repeat_time=str2num(get(handles.edit20,'String'));
state.spc.acq.SPCdata{board}.display_time=str2num(get(handles.edit19,'String'));

% SPCdata.dead_time_comp
state.spc.acq.SPCdata{board}.dead_time_comp=get(handles.edit26,'Value');
%state.spc.acq.SPCdata{board}.dead_time_comp=str2num(get(handles.edit26,'String'));




%state.spc.acq.SPCdata{board}.base_adr=str2num(get(handles.edit1,'String'));
%state.spc.acq.SPCdata{board}.init=str2num(get(handles.edit2,'String'));
state.spc.acq.SPCdata{board}.cfd_limit_low=str2num(get(handles.edit3,'String'));
%state.spc.acq.SPCdata{board}.cfd_limit_high=str2num(get(handles.edit4,'String'));
state.spc.acq.SPCdata{board}.cfd_zc_level=str2num(get(handles.edit5,'String'));
%state.spc.acq.SPCdata{board}.cfd_holdoff=str2num(get(handles.edit6,'String'));
state.spc.acq.SPCdata{board}.sync_zc_level=str2num(get(handles.edit7,'String'));
state.spc.acq.SPCdata{board}.sync_holdoff=str2num(get(handles.edit8,'String'));
state.spc.acq.SPCdata{board}.sync_threshold=str2num(get(handles.edit9,'String'));
state.spc.acq.SPCdata{board}.tac_range=str2num(get(handles.edit10,'String'));
state.spc.acq.SPCdata{board}.sync_freq_div=str2num(get(handles.edit11,'String'));
state.spc.acq.SPCdata{board}.tac_gain=str2num(get(handles.edit12,'String'));
state.spc.acq.SPCdata{board}.tac_offset=str2num(get(handles.edit13,'String'));
state.spc.acq.SPCdata{board}.tac_limit_low=str2num(get(handles.edit14,'String'));
state.spc.acq.SPCdata{board}.tac_limit_high=str2num(get(handles.edit15,'String'));
state.spc.acq.SPCdata{board}.ext_latch_delay=str2num(get(handles.edit17,'String'));
%state.spc.acq.SPCdata{board}.mem_bank=str2num(get(handles.edit25,'String'));
state.spc.acq.SPCdata{board}.scan_control=str2num(get(handles.edit27,'String'));
state.spc.acq.SPCdata{board}.routing_mode=str2num(get(handles.edit28,'String'));
state.spc.acq.SPCdata{board}.tac_enable_hold=str2num(get(handles.edit29,'String'));
%state.spc.acq.SPCdata{board}.pci_card_no=str2num(get(handles.edit30,'String'));
state.spc.acq.SPCdata{board}.test_eep=str2num(get(handles.edit32,'String'));
state.spc.acq.SPCdata{board}.scan_size_x=str2num(get(handles.edit33,'String'));
state.spc.acq.SPCdata{board}.scan_size_y=str2num(get(handles.edit34,'String'));
state.spc.acq.SPCdata{board}.scan_rout_x=str2num(get(handles.edit35,'String'));
state.spc.acq.SPCdata{board}.scan_rout_y=str2num(get(handles.edit36,'String'));
state.spc.acq.SPCdata{board}.scan_polarity=str2num(get(handles.edit37,'String'));
state.spc.acq.SPCdata{board}.scan_flyback=str2num(get(handles.edit38,'String'));
state.spc.acq.SPCdata{board}.scan_borders=str2num(get(handles.edit39,'String'));
state.spc.acq.SPCdata{board}.pixel_clock=str2num(get(handles.edit40,'String'));
state.spc.acq.SPCdata{board}.line_compression=str2num(get(handles.edit41,'String'));
state.spc.acq.SPCdata{board}.trigger=str2num(get(handles.edit42,'String'));
state.spc.acq.SPCdata{board}.pixel_time=str2num(get(handles.edit43,'String'))*1e-6;
state.spc.acq.SPCdata{board}.ext_pixclk_div=str2num(get(handles.edit44,'String'));
state.spc.acq.SPCdata{board}.rate_count_time=str2num(get(handles.edit45,'String'));
%state.spc.acq.SPCdata{board}.macro_time_clk=str2num(get(handles.edit46,'String'));
state.spc.acq.SPCdata{board}.add_select=str2num(get(handles.edit47,'String'));
%state.spc.acq.SPCdata{board}.adc_zoom=str2num(get(handles.edit48,'String'));

FLIM_setParameters(board-1);
FLIM_getParameters(board-1);
FLIM_FillParameters;

