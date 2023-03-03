function [HOG_feats, MBHx_feats, MBHy_feats] = getDescriptors(root_dir, subject, sequence, testing_seq)
first_traj_flag = 0;


for subj_i = 1 : length(subject) 
    for seq_i = 1:length(sequence) - testing_seq
        
        traj_name = strcat(root_dir, 'Trajectories/' , subject{subj_i},sequence{seq_i},'.mat')
        
        %Trajectories Path
        traj_desc_cmplt = load(traj_name);
        traj_desc_cmplt = traj_desc_cmplt.descriptors;
        
        % Get the number of passed trajectories.
        [ntraj, ~] = size(traj_desc_cmplt);
        
        %Create space for the output.
        C_HOG = double(zeros(ntraj, 96));
        C_MBHx = double(zeros(ntraj, 96));
        C_MBHy = double(zeros(ntraj, 96));
        
        % Copy the respective descriptors
        C_HOG(:,1:96) = traj_desc_cmplt(:,41:136);
        C_MBHx(:,1:96) = traj_desc_cmplt(:,245:340);
        C_MBHy(:,1:96) = traj_desc_cmplt(:,341:436);
        
        % Create random numbers if descriptors are large in quantity.
        % we want to get 1 million features to buils a codebook
        if(size(C_HOG,1) > 16000)
            limit = 16000;
            out = randperm(size(C_HOG,1));
            random_nos = out(1:limit);
            
            %Copy random descriptors.
            for rando_no_i=1:size(random_nos,2)
                HOG(rando_no_i,:)= C_HOG(random_nos(1,rando_no_i),:);
                MBHx(rando_no_i,:) = C_MBHx(random_nos(1,rando_no_i),:);
                MBHy(rando_no_i,:) = C_MBHy(random_nos(1,rando_no_i),:);
            end
        else
            HOG= C_HOG;
            MBHx = C_MBHx;
            MBHy = C_MBHy;
        end
        
        
        % Merge local descriptor of each file into a main single file.
        if(first_traj_flag == 0)
            HOG_feats = HOG;
            MBHx_feats = MBHx;
            MBHy_feats = MBHy;
        else
            HOG_feats = vertcat(HOG_feats, HOG);
            MBHx_feats = vertcat(MBHx_feats, MBHx);
            MBHy_feats = vertcat(MBHy_feats, MBHy);
        end
        first_traj_flag = first_traj_flag +1;        
        clear 'C_HOG';  clear 'C_MBHx'; clear 'C_MBHy'; clear 'HOG';  clear 'MBHx'; clear 'MBHy';
    end
end

 
% size(HOG_feats)
% size(MBHx_feats)
% size(MBHy_feats)
