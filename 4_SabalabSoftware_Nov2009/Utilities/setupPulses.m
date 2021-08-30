function setupPulses
% setup pulse patterns from a set
% cond | (string) defines a condition to choose from (for example, a 
%        particular pulse pattern set and a rule for selection
% 
% to be used as 'function' entry in cycle definition
% add to function entry in the position before your experiment
%
% Andrew Landau 180316

global state

% NOTE - this is where the specificity is determined
cond = 'epspAP_m4_p16_r4';

if ~ischar(cond), fprintf(2,'condition not valid, using default pulse\n'); end

switch cond
    case 'epspAP_m4_p16_r4'
        % EPSP-AP interactions, from minus 4ms to plus 16ms in 4ms res.
        % Assumes that uncaging happens at 200ms
        
        if ~isfield(state.cycle, 'randPulseOptions') || ~isfield(state.cycle, 'randPulseUsage')
            % Define positions
            rPosDefAP = [11 9 14:2:20 10 9]; % AP Pulse patterns (196:4:216, none, 200)ms
            rPosDefUC = [ones(1,length(rPosDefAP)-1) 0]; % Blaster patterns, (On except for AP alone)
            
            state.cycle.randPulseOptions = [rPosDefAP; rPosDefUC];
            state.cycle.randPulseUsage = ones(1,size(state.cycle.randPulseOptions,2));
        end
        
        % Reset options if all used up
        if all(~state.cycle.randPulseUsage)
            state.cycle.randPulseUsage = ones(1,size(state.cycle.randPulseOptions,2));
        end
        
        possChoice = find(state.cycle.randPulseUsage);
        numChoice = randperm(length(possChoice));
        numChoice = numChoice(1);
        pulse = state.cycle.randPulseOptions(1, possChoice(numChoice));
        blast = state.cycle.randPulseOptions(2, possChoice(numChoice));
        state.cycle.randPulseUsage(possChoice(numChoice)) = 0;
        
        state.cycle.da0List(state.cycle.currentCyclePosition) = pulse;
        state.cycle.blaster = blast;
        
%         fprintf('\nFromSetupPulses:\nPulseToUse0: %d, Blaster = %d\n',pulse,blast); %#ATL
end