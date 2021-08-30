function clearBlasterPositions

global state;

state.blaster.indexList = [];
state.blaster.XList=[];
state.blaster.YList=[];
state.blaster.indexYList=[];
state.blaster.indexXList=[];

try
		updateReferenceImage
catch
end

state.blaster.allConfigs={};

state.blaster.allConfigs(end+1, :)={'Default', [1 0 0.5 20 0 0]};

state.blaster.multilocs=[];

makeBlasterConfigMenu