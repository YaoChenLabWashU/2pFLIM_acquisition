function ivSetChannelIndex
	global state
	
	if state.imageViewer.selectionMenuValue>=1 & state.imageViewer.selectionMenuValue<=4	% chanenls 1-4
		state.imageViewer.selectionChannel=state.imageViewer.selectionMenuValue;
		state.imageViewer.selectionChannelIndex=state.imageViewer.selectionChannel;
		state.imageViewer.selectionChannelIsProj=0;
	elseif state.imageViewer.selectionMenuValue>=5 & state.imageViewer.selectionMenuValue<=8 % channels 11-14
		state.imageViewer.selectionChannel=state.imageViewer.selectionMenuValue-4+10;
		state.imageViewer.selectionChannelIndex=state.imageViewer.selectionChannel-10;
		state.imageViewer.selectionChannelIsProj=0;
	elseif state.imageViewer.selectionMenuValue>=9 & state.imageViewer.selectionMenuValue<=12	% channels 1-4 projections
		state.imageViewer.selectionChannel=state.imageViewer.selectionMenuValue-8;
		state.imageViewer.selectionChannelIndex=state.imageViewer.selectionChannel;
		state.imageViewer.selectionChannelIsProj=1;
	elseif state.imageViewer.selectionMenuValue>=13 & state.imageViewer.selectionMenuValue<=16 % channels 11-14 projections
		state.imageViewer.selectionChannel=state.imageViewer.selectionMenuValue-12+10;
		state.imageViewer.selectionChannelIndex=state.imageViewer.selectionChannel-10;
		state.imageViewer.selectionChannelIsProj=1;		
	elseif state.imageViewer.selectionMenuValue==17 
		state.imageViewer.selectionChannel=0;
		state.imageViewer.selectionChannelIndex=0;
		state.imageViewer.selectionChannelIsProj=0;
	end
	
	if state.imageViewer.morphMenuValue>=1 & state.imageViewer.morphMenuValue<=4	% chanenls 1-4
		state.imageViewer.morphChannel=state.imageViewer.morphMenuValue;
		state.imageViewer.morphChannelIndex=state.imageViewer.morphChannel;
		state.imageViewer.morphChannelIsProj=0;
	elseif state.imageViewer.morphMenuValue>=5 & state.imageViewer.morphMenuValue<=8 % channels 11-14
		state.imageViewer.morphChannel=state.imageViewer.morphMenuValue-4+10;
		state.imageViewer.morphChannelIndex=state.imageViewer.morphChannel-10;
		state.imageViewer.morphChannelIsProj=0;
	elseif state.imageViewer.morphMenuValue>=9 & state.imageViewer.morphMenuValue<=12	% channels 1-4 projections
		state.imageViewer.morphChannel=state.imageViewer.morphMenuValue-8;
		state.imageViewer.morphChannelIndex=state.imageViewer.morphChannel;
		state.imageViewer.morphChannelIsProj=1;
	elseif state.imageViewer.morphMenuValue>=13 & state.imageViewer.morphMenuValue<=16 % channels 11-14 projections
		state.imageViewer.morphChannel=state.imageViewer.morphMenuValue-12+10;
		state.imageViewer.morphChannelIndex=state.imageViewer.morphChannel-10;
		state.imageViewer.morphChannelIsProj=1;		
	end
