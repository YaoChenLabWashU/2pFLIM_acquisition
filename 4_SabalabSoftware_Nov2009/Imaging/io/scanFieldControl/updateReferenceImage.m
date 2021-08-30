function updateReferenceImage
	global state imageData
    
    blastRadius=0.5; %radius of circle in microns to represent blast location...
	try
		if ~ishandle(state.internal.refImage) | ~ishandle(state.internal.refFigure)
			return
		end
		if ~strcmp('on', get(state.internal.refFigure, 'Visible'))
			return
		end


		startImage=	zeros(state.acq.linesPerFrame, state.acq.pixelsPerLine, 3);
		if all(size(state.acq.trackerReferenceAll)==[state.acq.linesPerFrame state.acq.pixelsPerLine])
			startImage(:,:,1) = ...
				min(max(...
				(state.acq.trackerReferenceAll - ...
				getfield(state.internal, ['lowPixelValue' num2str(state.acq.trackerChannel)])) / ...
				max(...
					getfield(state.internal, ['highPixelValue' num2str(state.acq.trackerChannel)]) ...
					-getfield(state.internal, ['lowPixelValue' num2str(state.acq.trackerChannel)])...
					,1)...
				,0)...
				,1);
		end
		
		im=mean(imageData{state.acq.trackerChannel},3);
		if all(size(im)==[state.acq.linesPerFrame state.acq.pixelsPerLine])
			startImage(:,:,2) = ...
				min(max(...
				(im - ...
				getfield(state.internal, ['lowPixelValue' num2str(state.acq.trackerChannel)])) / ...
				max(...
					getfield(state.internal, ['highPixelValue' num2str(state.acq.trackerChannel)]) ...
					-getfield(state.internal, ['lowPixelValue' num2str(state.acq.trackerChannel)])...
					,1)...
				,0)...
				,1);
		end

		set(state.internal.refImage, 'CData', startImage);

		h=[state.internal.refPoints(ishandle(state.internal.refPoints)) state.internal.refText(ishandle(state.internal.refText))];
		if ~isempty(h)
			delete(h);
			state.internal.refPoints=[];
			state.internal.refText=[];
		end

		if 1 %state.blaster.active
 			if state.blaster.screenCoord
%                 if state.acq.zoomFactor == 5  %finish this!!!!!
%                     span=
                for counter=1:length(state.blaster.indexList)
					if state.blaster.active && any(counter==state.blaster.allConfigs{state.blaster.currentConfig, 2}(:,1))
						color='cyan';
					else
						color='black';
					end
%  					state.internal.refPoints(counter)=line(state.blaster.indexXList(counter), state.blaster.indexYList(counter), ...
% 						'Parent', state.internal.refAxis, 'LineWidth', 2.5, 'Marker', 'o', 'MarkerEdgeColor', 'White', 'MarkerFaceColor', color);
                    
                    %modified- start FS MOD
                    
                    
                    ppm=10;  %approximate for 256x256, 20x zoom....
                    
                    NOP=100;
                    radius=blastRadius*ppm; %ppm=pixels per micron
                    THETA=linspace(0,2*pi,NOP);                  
                    RHO=ones(1,NOP)*radius;
                    [X,Y] = pol2cart(THETA,RHO);
                    X=X+state.blaster.indexXList(counter);
                    Y=Y+state.blaster.indexYList(counter);
%  					state.internal.refPoints(counter)=line(state.blaster.indexXList(counter), state.blaster.indexYList(counter), ...
% 						'Parent', state.internal.refAxis, 'LineWidth', 2.5);
                    state.internal.refPoints(counter)=line(X, Y, ... % for now I'm not drawing the center of the circle until I can figure out...
						'Parent', state.internal.refAxis);  % to get the circles updated as I change the blaster positions...

                    %modified- end
                    
 					state.internal.refText(counter) = text(state.blaster.indexXList(counter)+6, state.blaster.indexYList(counter)+6, num2str(counter), ...
						'Parent', state.internal.refAxis, 'color', 'blue');
				end
			else	% using absolute coordinates
				disp('updateReferenceImage : needs code to draw in absolute coordinates');
			end
		end
    catch
		disp(['updateReferenceImage : ' lasterr]);
    end
	
	if state.analysis.analysisMode==2 | (state.analysis.analysisMode==4 & state.acq.lineScan)
		if state.acq.lineScan & (size(state.analysis.roiDefs,1) >= state.analysis.numberOfROI)
			colorList='brkgmcykkkkkkkkkk';
			for roiCounter=1:state.analysis.numberOfROI
				state.internal.refPoints(end+1)=line(state.analysis.roiDefs(roiCounter, 1:2), ...
					[round(state.acq.linesPerFrame/2) round(state.acq.linesPerFrame/2)], ...
					'Parent', state.internal.refAxis, 'LineWidth', 2.5, 'color', colorList(roiCounter));
			end
		end
	elseif state.analysis.analysisMode==3 | (state.analysis.analysisMode==4 & ~state.acq.lineScan)
		if ~state.acq.lineScan & (size(state.analysis.roiDefs2D,1) >= state.analysis.numberOfROI)
			colorList='brkgmcykkkkkkkkkk';
			for roiCounter=1:state.analysis.numberOfROI
				state.internal.refPoints(end+1)=line(...
					[state.analysis.roiDefs2D(roiCounter, 1) state.analysis.roiDefs2D(roiCounter, 1:2) state.analysis.roiDefs2D(roiCounter, 2:-1:1)], ...
					[state.analysis.roiDefs2D(roiCounter, 3:4) state.analysis.roiDefs2D(roiCounter, 4:-1:3) state.analysis.roiDefs2D(roiCounter, 3)], ...
					'Parent', state.internal.refAxis, 'LineWidth', 2.5, 'color', colorList(roiCounter));
			end
		end	
    end
    
%     function [zoomLookup, spanLookup]=returnLookups
%         zoomLookup = [...
%             1.0000
%             1.1000
%             1.2000
%             1.3000
%             1.4000
%             1.5000
%             1.6000
%             1.7000
%             1.8000
%             1.9000
%             2.0000
%             2.1000
%             2.2000
%             2.3000
%             2.4000
%             2.5000
%             2.6000
%             2.7000
%             2.8000
%             2.9000
%             3.0000
%             3.1000
%             3.2000
%             3.3000
%             3.4000
%             3.5000
%             3.6000
%             3.7000
%             3.8000
%             3.9000
%             4.0000
%             4.1000
%             4.2000
%             4.3000
%             4.4000
%             4.5000
%             4.6000
%             4.7000
%             4.8000
%             4.9000
%             5.0000
%             5.1000
%             5.2000
%             5.3000
%             5.4000
%             5.5000
%             5.6000
%             5.7000
%             5.8000
%             5.9000
%             6.0000
%             6.1000
%             6.2000
%             6.3000
%             6.4000
%             6.5000
%             6.6000
%             6.7000
%             6.8000
%             6.9000
%             7.0000
%             7.1000
%             7.2000
%             7.3000
%             7.4000
%             7.5000
%             7.6000
%             7.7000
%             7.8000
%             7.9000
%             8.0000
%             8.1000
%             8.2000
%             8.3000
%             8.4000
%             8.5000
%             8.6000
%             8.7000
%             8.8000
%             8.9000
%             9.0000
%             9.1000
%             9.2000
%             9.3000
%             9.4000
%             9.5000
%             9.6000
%             9.7000
%             9.8000
%             9.9000
%            10.0000
%            10.1000
%            10.2000
%            10.3000
%            10.4000
%            10.5000
%            10.6000
%            10.7000
%            10.8000
%            10.9000
%            11.0000
%            11.1000
%            11.2000
%            11.3000
%            11.4000
%            11.5000
%            11.6000
%            11.7000
%            11.8000
%            11.9000
%            12.0000
%            12.1000
%            12.2000
%            12.3000
%            12.4000
%            12.5000
%            12.6000
%            12.7000
%            12.8000
%            12.9000
%            13.0000
%            13.1000
%            13.2000
%            13.3000
%            13.4000
%            13.5000
%            13.6000
%            13.7000
%            13.8000
%            13.9000
%            14.0000
%            14.1000
%            14.2000
%            14.3000
%            14.4000
%            14.5000
%            14.6000
%            14.7000
%            14.8000
%            14.9000
%            15.0000
%            15.1000
%            15.2000
%            15.3000
%            15.4000
%            15.5000
%            15.6000
%            15.7000
%            15.8000
%            15.9000
%            16.0000
%            16.1000
%            16.2000
%            16.3000
%            16.4000
%            16.5000
%            16.6000
%            16.7000
%            16.8000
%            16.9000
%            17.0000
%            17.1000
%            17.2000
%            17.3000
%            17.4000
%            17.5000
%            17.6000
%            17.7000
%            17.8000
%            17.9000
%            18.0000
%            18.1000
%            18.2000
%            18.3000
%            18.4000
%            18.5000
%            18.6000
%            18.7000
%            18.8000
%            18.9000
%            19.0000
%            19.1000
%            19.2000
%            19.3000
%            19.4000
%            19.5000
%            19.6000
%            19.7000
%            19.8000
%            19.9000
%            20.0000
%            20.1000
%            20.2000
%            20.3000
%            20.4000
%            20.5000
%            20.6000
%            20.7000
%            20.8000
%            20.9000
%            21.0000
%            21.1000
%            21.2000
%            21.3000
%            21.4000
%            21.5000
%            21.6000
%            21.7000
%            21.8000
%            21.9000
%            22.0000
%            22.1000
%            22.2000
%            22.3000
%            22.4000
%            22.5000
%            22.6000
%            22.7000
%            22.8000
%            22.9000
%            23.0000
%            23.1000
%            23.2000
%            23.3000
%            23.4000
%            23.5000
%            23.6000
%            23.7000
%            23.8000
%            23.9000
%            24.0000
%            24.1000
%            24.2000
%            24.3000
%            24.4000
%            24.5000
%            24.6000
%            24.7000
%            24.8000
%            24.9000
%            25.0000
%            25.1000
%            25.2000
%            25.3000
%            25.4000
%            25.5000
%            25.6000
%            25.7000
%            25.8000
%            25.9000
%            26.0000
%            26.1000
%            26.2000
%            26.3000
%            26.4000
%            26.5000
%            26.6000
%            26.7000
%            26.8000
%            26.9000
%            27.0000
%            27.1000
%            27.2000
%            27.3000
%            27.4000
%            27.5000
%            27.6000
%            27.7000
%            27.8000
%            27.9000
%            28.0000
%            28.1000
%            28.2000
%            28.3000
%            28.4000
%            28.5000
%            28.6000
%            28.7000
%            28.8000
%            28.9000
%            29.0000
%            29.1000
%            29.2000
%            29.3000
%            29.4000
%            29.5000
%            29.6000
%            29.7000
%            29.8000
%            29.9000
%            30.0000];
%  
%        spanLookup = [...
%               206.5000
%               202.3625
%               198.2250
%               194.0875
%               189.9500
%               185.8125
%               181.6750
%               177.5375
%               173.4000
%               169.2625
%               165.1250
%               160.9875
%               156.8500
%               152.7125
%               148.5750
%               144.4375
%               140.3000
%               136.1625
%               132.0250
%               127.8875
%               123.7500
%               119.6125
%               115.4750
%               111.3375
%               107.2000
%               103.0625
%                98.9250
%                94.7875
%                90.6500
%                86.5125
%                82.3750
%                78.2375
%                74.1000
%                69.9625
%                65.8250
%                61.6875
%                57.5500
%                53.4125
%                49.2750
%                45.1375
%                41.0000
%                40.5850
%                40.1700
%                39.7550
%                39.3400
%                38.9250
%                38.5100
%                38.0950
%                37.6800
%                37.2650
%                36.8500
%                36.4350
%                36.0200
%                35.6050
%                35.1900
%                34.7750
%                34.3600
%                33.9450
%                33.5300
%                33.1150
%                32.7000
%                32.2850
%                31.8700
%                31.4550
%                31.0400
%                30.6250
%                30.2100
%                29.7950
%                29.3800
%                28.9650
%                28.5500
%                28.1350
%                27.7200
%                27.3050
%                26.8900
%                26.4750
%                26.0600
%                25.6450
%                25.2300
%                24.8150
%                24.4000
%                23.9850
%                23.5700
%                23.1550
%                22.7400
%                22.3250
%                21.9100
%                21.4950
%                21.0800
%                20.6650
%                20.2500
%                20.1750
%                20.1000
%                20.0250
%                19.9500
%                19.8750
%                19.8000
%                19.7250
%                19.6500
%                19.5750
%                19.5000
%                19.4250
%                19.3500
%                19.2750
%                19.2000
%                19.1250
%                19.0500
%                18.9750
%                18.9000
%                18.8250
%                18.7500
%                18.6750
%                18.6000
%                18.5250
%                18.4500
%                18.3750
%                18.3000
%                18.2250
%                18.1500
%                18.0750
%                18.0000
%                17.9250
%                17.8500
%                17.7750
%                17.7000
%                17.6250
%                17.5500
%                17.4750
%                17.4000
%                17.3250
%                17.2500
%                17.1750
%                17.1000
%                17.0250
%                16.9500
%                16.8750
%                16.8000
%                16.7250
%                16.6500
%                16.5750
%                16.5000
%                16.4200
%                16.3400
%                16.2600
%                16.1800
%                16.1000
%                16.0200
%                15.9400
%                15.8600
%                15.7800
%                15.7000
%                15.6200
%                15.5400
%                15.4600
%                15.3800
%                15.3000
%                15.2200
%                15.1400
%                15.0600
%                14.9800
%                14.9000
%                14.8200
%                14.7400
%                14.6600
%                14.5800
%                14.5000
%                14.4200
%                14.3400
%                14.2600
%                14.1800
%                14.1000
%                14.0200
%                13.9400
%                13.8600
%                13.7800
%                13.7000
%                13.6200
%                13.5400
%                13.4600
%                13.3800
%                13.3000
%                13.2200
%                13.1400
%                13.0600
%                12.9800
%                12.9000
%                12.8200
%                12.7400
%                12.6600
%                12.5800
%                12.5000
%                12.4460
%                12.3920
%                12.3380
%                12.2840
%                12.2300
%                12.1760
%                12.1220
%                12.0680
%                12.0140
%                11.9600
%                11.9060
%                11.8520
%                11.7980
%                11.7440
%                11.6900
%                11.6360
%                11.5820
%                11.5280
%                11.4740
%                11.4200
%                11.3660
%                11.3120
%                11.2580
%                11.2040
%                11.1500
%                11.0960
%                11.0420
%                10.9880
%                10.9340
%                10.8800
%                10.8260
%                10.7720
%                10.7180
%                10.6640
%                10.6100
%                10.5560
%                10.5020
%                10.4480
%                10.3940
%                10.3400
%                10.2860
%                10.2320
%                10.1780
%                10.1240
%                10.0700
%                10.0160
%                 9.9620
%                 9.9080
%                 9.8540
%                 9.8000
%                 9.7750
%                 9.7500
%                 9.7250
%                 9.7000
%                 9.6750
%                 9.6500
%                 9.6250
%                 9.6000
%                 9.5750
%                 9.5500
%                 9.5250
%                 9.5000
%                 9.4750
%                 9.4500
%                 9.4250
%                 9.4000
%                 9.3750
%                 9.3500
%                 9.3250
%                 9.3000
%                 9.2750
%                 9.2500
%                 9.2250
%                 9.2000
%                 9.1750
%                 9.1500
%                 9.1250
%                 9.1000
%                 9.0750
%                 9.0500
%                 9.0250
%                 9.0000
%                 8.9750
%                 8.9500
%                 8.9250
%                 8.9000
%                 8.8750
%                 8.8500
%                 8.8250
%                 8.8000
%                 8.7750
%                 8.7500
%                 8.7250
%                 8.7000
%                 8.6750
%                 8.6500
%                 8.6250
%                 8.6000
%                 8.5750
%                 8.5500];
%     end