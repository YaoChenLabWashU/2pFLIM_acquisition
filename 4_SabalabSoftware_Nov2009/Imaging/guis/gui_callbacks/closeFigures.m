function closeFigures
global gh state

% Function that closes all the figures open in the DAQ software

for channelCounter = 1:state.init.maximumNumberOfInputChannels
	try
		eval(['close(''Acquisition of Channel ' num2str(channelCounter)  ''');']);
		eval(['close(''Max Projection of Channel ' num2str(channelCounter) ''');']);
	catch
	end
end