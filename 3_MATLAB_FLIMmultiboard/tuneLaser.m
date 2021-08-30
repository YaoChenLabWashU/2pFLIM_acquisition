function tuneLaser(wlen)
lcWindow=guihandles(laserControl);
set(lcWindow.waveln,'String',num2str(wlen));
laserControl('waveln_Callback',lcWindow.waveln,[],lcWindow); 