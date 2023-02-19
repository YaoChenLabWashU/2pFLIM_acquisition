function [pnameOut]=Yao_outputWaves

global stateYao

pnameOut=[];
if stateYao.processCycles(1) ~= 0
    
    
    
    global AcqTime
    waveo('AcqTime', nan(1, max(max(stateYao.CyclePositions)) ) );
    
    
    for numCycle = stateYao.processCycles'
        
        isDendrite = 0;
        if isnumeric( stateYao.CycleIdentification{numCycle,2} )
            isDendrite = 1;
        end
        
        
        
        for iImg = 1:size( stateYao.CyclePositions ,1)
            if stateYao.CyclePositions(iImg,numCycle) ~= 0
                AcqTime( stateYao.CyclePositions(iImg,numCycle) ) =...
                    stateYao.AcqTime(iImg,numCycle);
            end
        end
        
        
        
        if isDendrite
            
            basename = sprintf('EmpLifetime_p%dd',...
                numCycle);
            
            % Initialize all waves
            %   How many different cells are there?
            nCell = 0;
            for iImg = 1:size(stateYao.CyclePositions,1)
                if stateYao.CyclePositions(iImg,numCycle) ~= 0
                    nCell = max([nCell size(stateYao.images.I_ROI_stack{numCycle}{iImg},3)]);
                end
            end
            
            
            for iCell = 1:nCell
                basename = sprintf('EmpLifeTime_p%dd%d',...
                    numCycle, iCell);
                
                eval(sprintf('global %s',basename))
                
                waveo(basename, nan(1, max(max(stateYao.CyclePositions)) ) );
            end
            
            % Go through each image in the cycle to get lifetime info
            for iImg = 1:size( stateYao.CyclePositions ,1)
                if stateYao.CyclePositions(iImg,numCycle) ~= 0
                    if stateYao.ignoreImage(iImg,numCycle) == 0
                        
                        % to-do: multi-position, multi-dendrite
                        % cellIdxList = stateYao.cellIdx{numCycle}{iImg};
                        cellIdxList = 1:nCell;
                        
                        % for iCell = 1:size( cellIdxList ,1)
                          for iCell = 1:nCell %Yao changed 2/1/2021
                            % idxCell = cellIdxList(iCell, 1);
                            idxCell = cellIdxList(iCell); %Yao changed 2/1/2021
                            % iCell_true = cellIdxList(iCell,2);
                            iCell_true = idxCell;
                            
                            for iType = 1:2
                                basename = sprintf('EmpLifeTime_p%dd%d',...
                                    numCycle,iCell_true);
                                
                                val_LifetimeMap =...
                                    stateYao.Results.spc_calculateROIvals.LifetimeMap{numCycle}{iImg}(idxCell);
                                
                                if ~isempty(val_LifetimeMap)
                                    numImg = stateYao.CyclePositions(iImg,numCycle);
                                    
                                    eval(sprintf('%s(numImg) = val_LifetimeMap;',...
                                        basename))
                                end
                            end
                            
                        end
                        
                        
                    end
                end
            end
            
            
        else
            
            basename = sprintf('EmpLifetime_p%d',...
                numCycle);
            
            
            
            % Initialize all waves
            %   How many different cells are there?
            nCell = 0;
            for iImg = 1:size(stateYao.CyclePositions,1)
                if stateYao.CyclePositions(iImg,numCycle) ~= 0
                    nCell = max([nCell size(stateYao.images.I_cell_stack{numCycle}{iImg},3)]);
                end
            end
            
            
            for iType = 1:2
                if iType == 1
                    t = 'n';
                else
                    t = 'c';
                end
                
                for iCell = 1:nCell
                    basename = sprintf('EmpLifeTime_p%d%s%d',...
                        numCycle,t,iCell);
                    
                    eval(sprintf('global %s',basename))
                    
                    
                    
                    waveo(basename, nan(1, max(max(stateYao.CyclePositions)) ) );
                end
            end
            
            
            
            % Go through each image in the cycle to get lifetime info
            for iImg = 1:size( stateYao.CyclePositions ,1)
                if stateYao.CyclePositions(iImg,numCycle) ~= 0
                    if stateYao.ignoreImage(iImg,numCycle) == 0
                        
                        cellIdxList = stateYao.cellIdx{numCycle}{iImg};
                        
                        for iCell = 1:size( cellIdxList ,1)
                            idxCell = cellIdxList(iCell,1);
                            iCell_true = cellIdxList(iCell,2);
                            
                            
                            for iType = 1:2
                                if iType == 1
                                    t = 'n';
                                else
                                    t = 'c';
                                end
                                
                                basename = sprintf('EmpLifeTime_p%d%s%d',...
                                    numCycle,t,iCell_true);
%                                 numCycle
%                                 iImg
%                                 idxCell
%                                 iType
                                
                                val_LifetimeMap =...
                                    stateYao.Results.spc_calculateROIvals.LifetimeMap{numCycle}{iImg}(idxCell,iType);
                                
                                if ~isempty(val_LifetimeMap)
                                    numImg = stateYao.CyclePositions(iImg,numCycle);
                                    
                                    eval(sprintf('%s(numImg) = val_LifetimeMap;',...
                                        basename))
                                end
                            end
                            
                        end
                        
                        
                    end
                end
            end
            
            
            
        end
        
    end
    
    
    %basename=stateYao.baseName;
    basename=strcat('yc',stateYao.baseName(end-3:end));
    [pnameOut]=exportAllToIgorYao(basename, '*', 0, 1, 0,1000000);
    
    
    
    
    
    
    %% Clear waves
    if exist('AcqTime','var')
        clearvars -GLOBAL AcqTime
    end
    
    for numCycle = stateYao.processCycles'
        
        isDendrite = 0;
        if isnumeric( stateYao.CycleIdentification{numCycle,2} )
            isDendrite = 1;
        end
        
        
        
        if isDendrite
            % Get filename
            basename = sprintf('EmpLifetime_p%dd%d',...
                numCycle,1);
            
            eval(sprintf('global %s',basename))
            
            
            
            if exist(basename,'var') % if basename exists as a variable.
                eval(sprintf('clearvars -GLOBAL %s', basename));
            end
            
            
        else
            
            
            
            
            % Initialize all waves
            %   How many different cells are there?
            nCell = 0;
            for iImg = 1:size(stateYao.CyclePositions,1)
                if stateYao.CyclePositions(iImg,stateYao.numCycle(numCycle)) ~= 0
                    nCell = max([nCell size(stateYao.images.I_cell_stack{numCycle}{iImg},3)]);
                end
            end
            
            
            for iType = 1:2
                if iType == 1
                    t = 'n';
                else
                    t = 'c';
                end
                
                for iCell = 1:nCell
                    basename = sprintf('EmpLifeTime_p%d%s%d',...
                        numCycle,t,iCell);
                    eval(sprintf('global %s', basename));
                    if exist(basename,'var')
                        eval(sprintf('clearvars -GLOBAL %s', basename));
                    end
                    
                end
            end
            
            
            
            
            
        end
    end
    
    
    
end