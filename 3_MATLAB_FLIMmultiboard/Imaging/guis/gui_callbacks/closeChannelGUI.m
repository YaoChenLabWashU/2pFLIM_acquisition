function closeChannelGUI
	global state gh

	uicontrol(gh.channelGUI.text4);
	if state.internal.channelChanged
		hideGUI('gh.channelGUI.figure1');
		updateChannelFlags;
		applyImagingInputParams;	
		state.internal.channelChanged=0;
	else
		hideGUI('gh.channelGUI.figure1');
		state.internal.channelChanged=0;
	end
	