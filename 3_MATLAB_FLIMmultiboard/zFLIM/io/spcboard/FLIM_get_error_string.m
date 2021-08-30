function error = FLIM_get_error_string (out1);

maxlength = 62;
dest_string(1:maxlength)='a';
[out2, error]=calllib('spcm32','SPC_get_error_string',out1,dest_string, maxlength);
