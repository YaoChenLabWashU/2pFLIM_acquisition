function [armed, measure, wait, timerout] = FLIM_decode_test_state (m,display)
% modified gy multiboard 201202
% m is module number from state.spc.acq.modulesInUse
global state;

if nargin == 0
    display = 1;
end

status=0;
[out status]=calllib('spcm32','SPC_test_state',m,status);

a=dec2bin(double(status));

%a = ['0000000000000000000', a];
a = ['00000000000000000000000000', a];
if display
    b=a(end-0);
    disp(['Stopped on overflow  ', a(end-0)]);
    disp(['Overflow occured  ', a(end-1)]);
    disp(['Stopped on expiration of collection timer  ', a(end-2)]);
    disp(['collection timer expired  ', a(end-3)]);
    disp(['Stopped on user command  ', a(end-4)]);
    disp(['Repeat timer expired  ', a(end-5)]);
    disp(['SPC measure  ', a(end-6)]);
    disp(['Measurement in progress (current bank)  ', a(end-7)]);%SPC_ARMED 0x80
    disp(['Second overflow of collection timer  ', a(end-8)]); %SPC_COLTIM_OVER 0x100
    disp(['Second overflow of repeat timer  ', a(end-9)]); %SPC_REPTIM_2OVER 0x200
    if state.spc.acq.SPCdata{m+1}.mode == 2
        disp(['Scan ready (data can be read)  ', a(end-10)]); %0x400
        disp(['Flow back of scan finished  ', a(end-11)]); %0x800
    elseif state.spc.acq.SPCdata{m+1}.mode == 5
        disp(['Fifo overflow, data lost  ', a(end-10)]); %0x400
        disp(['Fifo empty  ', a(end-11)]); %0x800
    end
    disp(['Wait for external trigger  ', a(end-12)]);  %0x1000
    if state.spc.acq.SPCdata{m+1}.mode == 2
        disp(['Sequencer is waiting for other bank to be armed ', a(end-13)]); % 0x2000
    elseif state.spc.acq.SPCdata{m+1}.mode == 5
        disp(['FIFO IMAGE measurement waits for the frame signal to stop  ', a(end-13)]); % 0x2000
    end
    disp(['disarmed (measurement stopped) by sequencer  ', a(end-14)]); % %0x4000
    disp(['hardware fill not finished  ', a(end-15)]); % %0x8000
    disp('--------');
end

armed = str2num(a(end-7));
measure = str2num(a(end-6));
wait = str2num(a(end-12));
timerout = str2num(a(end-2));