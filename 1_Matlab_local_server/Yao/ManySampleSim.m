function ManySampleSim = ManySampleSim(times)
global n;
% This function runs FLIMsim2 multiple times, puts the samples through the fitting functions, takes input that indicates
% the number of times, outputs each time 1) different sample populations in the
% format of histogram data;

for counter=1:times
    % Section 1: Generate samples
    FLIMsim2(20000, 3000, 6424)
    
    % Section 2: Save sample files with different names and move them to a
    % different folder.
    formatSpec='FLIM_Simulation(64Ch_2.1_0.7_0.6_0.4)/FLIMsim%d.mat';
    NewName=sprintf(formatSpec,counter);
    movefile('FLIMSimulation.mat', NewName);
     
end  

end

