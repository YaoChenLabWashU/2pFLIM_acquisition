function ivExportObjectAnalysis(prefix, clearMemory)
% function ivExportObjectAnalysis(objects, prefix, clearMemory)	
	global state
	
	if nargin<2
		clearMemory=0;
	end
	
	if nargin<1
		prefix='';
	end
	
	disp('Creating waves...');
	waveList=cell(1, 15*size(state.imageViewer.momentsResults,2));

% 					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 1)=[xc-len];
% 					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 2)=[yc-len];
% 					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 3)=mass;
% 					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 4)=pixSize;
% 					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 5)=lineAngle;
% 					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 6)=mI;
% 					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 7)=rTotal;
% 					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 8)=rMinor;
% 					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 9)=rMajor;
 
	for objectNumber=1:size(state.imageViewer.momentsResults,2)
		waveo(['o' num2str(objectNumber) '_G_mass'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 1, 3)));
		waveo(['o' num2str(objectNumber) '_R_mass'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 2, 3)));
		
		waveo(['o' num2str(objectNumber) '_G_size'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 1, 4)));
		waveo(['o' num2str(objectNumber) '_R_size'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 2, 4)));
		
		waveo(['o' num2str(objectNumber) '_G_theta'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 1, 5)));
		waveo(['o' num2str(objectNumber) '_R_theta'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 2, 5)));
		
		waveo(['o' num2str(objectNumber) '_G_momIn'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 1, 6)));
		waveo(['o' num2str(objectNumber) '_R_momIn'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 2, 6)));
		
		waveo(['o' num2str(objectNumber) '_G_inR'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 1, 7)));
		waveo(['o' num2str(objectNumber) '_R_inR'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 2, 7)));
		
		waveo(['o' num2str(objectNumber) '_G_inRminor'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 1, 8)));
		waveo(['o' num2str(objectNumber) '_R_inRminor'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 2, 8)));
		
		waveo(['o' num2str(objectNumber) '_G_inRmajor'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 1, 9)));
		waveo(['o' num2str(objectNumber) '_R_inRmajor'], ...
			squeeze(state.imageViewer.momentsResults(:, objectNumber, 2, 9)));

		
		waveo(['o' num2str(objectNumber) '_dCM'], ...
			sqrt(...
			(squeeze(state.imageViewer.momentsResults(:, objectNumber, 1, 1)) ...
			- squeeze(state.imageViewer.momentsResults(:, objectNumber, 2, 1))).^2 + ...
			(squeeze(state.imageViewer.momentsResults(:, objectNumber, 1, 2)) ...
			- squeeze(state.imageViewer.momentsResults(:, objectNumber, 2, 2))).^2)...
			);

		waveList{(objectNumber-1)*15 + 1} = ['o' num2str(objectNumber) '_G_mass'];
		waveList{(objectNumber-1)*15 + 2} = ['o' num2str(objectNumber) '_R_mass'];
		waveList{(objectNumber-1)*15 + 3} = ['o' num2str(objectNumber) '_G_size'];
		waveList{(objectNumber-1)*15 + 4} = ['o' num2str(objectNumber) '_R_size'];
		waveList{(objectNumber-1)*15 + 5} = ['o' num2str(objectNumber) '_G_momIn'];
		waveList{(objectNumber-1)*15 + 6} = ['o' num2str(objectNumber) '_R_momIn'];
		waveList{(objectNumber-1)*15 + 7} = ['o' num2str(objectNumber) '_G_inR'];
		waveList{(objectNumber-1)*15 + 8} = ['o' num2str(objectNumber) '_R_inR'];
		waveList{(objectNumber-1)*15 + 9} = ['o' num2str(objectNumber) '_G_inRminor'];
		waveList{(objectNumber-1)*15 + 10} = ['o' num2str(objectNumber) '_R_inRminor'];
		waveList{(objectNumber-1)*15 + 11} = ['o' num2str(objectNumber) '_G_inRmajor'];
		waveList{(objectNumber-1)*15 + 12} = ['o' num2str(objectNumber) '_R_inRmajor'];
		waveList{(objectNumber-1)*15 + 13} = ['o' num2str(objectNumber) '_dCM'];
		waveList{(objectNumber-1)*15 + 14} = ['o' num2str(objectNumber) '_G_theta'];
		waveList{(objectNumber-1)*15 + 15} = ['o' num2str(objectNumber) '_R_theta'];
	end
	
	disp('Exporting waves...');
	exportWave(waveList, prefix);
	
	if clearMemory
		disp('Killing waves...');
		kill(waveList, 'q');
	end