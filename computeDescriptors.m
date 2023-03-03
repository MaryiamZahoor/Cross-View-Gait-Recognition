function computeDescriptors(root_dir, subject, sequence)
% Root directory containing the video sequences
% This folder must have 'videos' and 'Trajectories' folders.
% The motion features will be saved into 'Trajectories' folder.
%root_dir = '/media/hassan/Seagate_Expansion_Drive/Datasets/Gait/NLPR/';

% Subject name in the database
%subject = {'fyc','hy','ljg','lqf','lsl','ml','nhz','rj','syj','wl','wq','wyc','xch','xxj','yjf','zc','zdx','zjg','zl','zyf'};

% Viewing Angles
%sequence = {'00_1', '00_2', '00_3', '00_4'};

%% Compute local descreiptors and saved into specified location
for subj_i = 1 : length(subject)
    for seq_i = 1 : length(sequence)        
        
        movieName = strcat(root_dir,'Videos/',subject{subj_i},'/',sequence{seq_i},'/',subject{subj_i},sequence{seq_i},'.avi');
        trajFolder  = strcat(root_dir,'Trajectories/',subject{subj_i},sequence{seq_i},'.mat');
        
        trajectory(movieName,trajFolder);         
    end
end

fprintf('++++++++++++++++++++++++++++++++++++++++++++ Local descriptors for all videos are computed ++++++++++++++++++++++++++++++++++++++++++++ \n');