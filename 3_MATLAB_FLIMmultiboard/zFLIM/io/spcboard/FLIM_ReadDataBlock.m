function FLIM_ReadDataBlock(pageNumber)

global state;

tempData(1024)=0.0;
[out1 state.spc.acq.mData]=calllib('spcm32','SPC_read_data_block',state.spc.acq.module,0,pageNumber,1,0,1023,tempData);