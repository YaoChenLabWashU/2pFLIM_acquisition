function setupBlasterConfigsByPos(pat)

global state;

state.blaster.allConfigs={};

for pos=1:length(state.blaster.indexList)
    state.blaster.allConfigs(end+1, :)={['pos' num2str(pos)], [pos pat 0.5 20 0 0]};
end

