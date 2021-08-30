function updateSavedScans(shift, scanCounter)
	global state

 
			zoomFactor = state.internal.saveScanInfo(scanCounter, 1);
			scanRotation  = state.internal.saveScanInfo(scanCounter, 2);
			postRotOffsetX = state.internal.saveScanInfo(scanCounter, 3);
			postRotOffsetY  = state.internal.saveScanInfo(scanCounter, 4);
			trackerX0 = state.internal.saveScanInfo(scanCounter, 5);
			trackerY0 = state.internal.saveScanInfo(scanCounter, 6);
			scanShiftX = state.internal.saveScanInfo(scanCounter, 7);
			scanShiftY = state.internal.saveScanInfo(scanCounter, 8);
			pixelShiftX = state.internal.saveScanInfo(scanCounter, 9);
			pixelShiftY = state.internal.saveScanInfo(scanCounter, 10);
			refShiftX = state.internal.saveScanInfo(scanCounter, 11);
			refShiftY = state.internal.saveScanInfo(scanCounter, 12);
			pzPos=state.internal.saveScanInfo(scanCounter, 13);
            relZ=state.internal.saveScanInfo(scanCounter, 14);
            
			pixelShiftY=shift(1)-trackerY0+1;
			pixelShiftX=shift(2)-trackerX0+1;
			
			DscanShiftX=2*state.acq.scanAmplitudeX*(pixelShiftX/state.acq.pixelsPerLine)/zoomFactor;
			DscanShiftY=2*state.acq.scanAmplitudeY*(pixelShiftY/state.acq.linesPerFrame)/zoomFactor;

			c = cos(scanRotation*pi/180);
			s = sin(scanRotation*pi/180);
			scanShiftX =  c * DscanShiftX + s * DscanShiftY;
			scanShiftY = -s * DscanShiftX + c * DscanShiftY;				

			postRotOffsetX=postRotOffsetX+scanShiftX;
			postRotOffsetY=postRotOffsetY+scanShiftY;		

			refShiftX = refShiftX + scanShiftX;
			refShiftY = refShiftY + scanShiftY;
			state.internal.needNewRotatedMirrorOutput=1;
			state.internal.needNewPcellRepeatedOutput=1;
			
			relevantInfo=[...
				zoomFactor ...
				scanRotation ...
				postRotOffsetX ...
				postRotOffsetY...
				trackerX0 ...
				trackerY0 ...
				scanShiftX ...
				scanShiftY ...
				pixelShiftX ...
				pixelShiftY ...
				refShiftX ...
				refShiftY ...
				pzPos ...
                relZ ...
			];

			state.internal.saveScanInfo(scanCounter, :)=relevantInfo;		

	%catch
	%	disp 'Error in updateSavedScans'
	%end