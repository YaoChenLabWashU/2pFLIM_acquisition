function doLaserCmd(cmd)
lcWindow=guihandles(laserControl);
set(lcWindow.laserCommand,'String',cmd);
laserControl('laserCommand_Callback',lcWindow.laserCommand,[],lcWindow); 