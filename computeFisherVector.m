function computeFisherVector(root_dir, cluster_no, subject, sequence)

%% Feature encoding
run('lib/encoding/toolbox/vl_setup');
clc;

fprintf('++++++++++++++++++++++++++++++++++++++++++++ Feature Encoding Started ++++++++++++++++++++++++++++++++++++++++++++ \n');

%pca_no = {96}; %{16,32,48,64,80,96};
descriptor_no = {'HOG', 'MBHx', 'MBHy'};
%cluster_no = {256}; %{32,64,128,256,512,1024,2048};

%for pca_no_i = 1:length(pca_no)
for subj_i = 1 : length(subject)
    for seq_i = 1:length(sequence)
        
        traj_name = strcat(root_dir,'Trajectories/',subject{subj_i},sequence{seq_i},'.mat');
        
        %Trajectories Path
        traj_desc_cmplt = load(traj_name);
        traj_desc_cmplt = traj_desc_cmplt.descriptors;
        
        % Get the number of passed trajectories.
        [ntraj, ~] = size(traj_desc_cmplt);
        
        %Create space for the output.
        HOG = double(zeros(ntraj, 96));
        MBHx = double(zeros(ntraj, 96));
        MBHy = double(zeros(ntraj, 96));
        
        % Copy the respective descriptors
        HOG(:,1:96) = traj_desc_cmplt(:,41:136);
        MBHx(:,1:96) = traj_desc_cmplt(:,245:340);
        MBHy(:,1:96) = traj_desc_cmplt(:,341:436);
        
        %             %Apply PCA
        %             if(pca_no{pca_no_i} < 96)
        %             [HOG_coeff,HOG_pca] = pca(HOG,'NumComponents',pca_no{pca_no_i});
        %             [MBHx_coeff,MBHx_pca] = pca(MBHx,'NumComponents',pca_no{pca_no_i});
        %             [MBHy_coeff,MBHy_pca] = pca(MBHy,'NumComponents',pca_no{pca_no_i});
        %             else
        %                 HOG_pca = HOG;
        %                 MBHx_pca = MBHx;
        %                 MBHy_pca = MBHy;
        %             end
        
        HOG_pca = HOG;
        MBHx_pca = MBHx;
        MBHy_pca = MBHy;
        
        
        for descriptor_no_i = 1 : length(descriptor_no)
            for cluster_no_i = 1 : length(cluster_no)
                
                strcat(traj_name, '  - and descriptor =  ', num2str(descriptor_no{descriptor_no_i}), '  - and  K = ', num2str(cluster_no{cluster_no_i}))
                mean_flag = 0 ; covariance_flag = 0; prior_flag = 0; encoding = '';
                
                mean_file = strcat(root_dir, descriptor_no{descriptor_no_i}, '/', num2str(cluster_no{cluster_no_i}), '/', descriptor_no{descriptor_no_i},'_','mean.mat')
                if( exist(mean_file, 'file') == 2)
                    mean = load(mean_file);
                    mean_field = fieldnames(mean,'-full');  
                    mean = getfield(mean, mean_field{1});   
                    mean_flag = 1;
                end
                
                covariance_file = strcat(root_dir, descriptor_no{descriptor_no_i}, '/', num2str(cluster_no{cluster_no_i}), '/', descriptor_no{descriptor_no_i},'_','covariance.mat');
                if( exist(covariance_file, 'file') == 2)
                    covariance = load(covariance_file);
                    covariance_field = fieldnames(covariance,'-full');  
                    covariance = getfield(covariance, covariance_field{1}); 
                    covariance_flag=1;
                end
                
                prior_file = strcat(root_dir,  descriptor_no{descriptor_no_i}, '/', num2str(cluster_no{cluster_no_i}), '/',descriptor_no{descriptor_no_i},'_','prior.mat');
                if( exist(prior_file, 'file') == 2)
                    prior = load(prior_file);
                    prior_field = fieldnames(prior,'-full');    
                    prior = getfield(prior, prior_field{1});    
                    prior_flag = 1;
                end
                
                if( mean_flag == 1 && covariance_flag == 1 && prior_flag == 1)
                    
                    % directory creation
                    destination_dir = strcat(root_dir,'FisherVector/', descriptor_no{descriptor_no_i}, '-', num2str(cluster_no{cluster_no_i}));
                    if( exist(destination_dir, 'file') ~= 7)              
                        mkdir(destination_dir);                    
                    end
                    
                    if(strcmp(descriptor_no{descriptor_no_i}, 'HOG'))       
                        data = HOG_pca';     
                    end
                    if(strcmp(descriptor_no{descriptor_no_i}, 'MBHx'))      
                        data = MBHx_pca';     
                    end
                    if(strcmp(descriptor_no{descriptor_no_i}, 'MBHy'))      
                        data = MBHy_pca';     
                    end
                    
                    % encoding
                    encoding = vl_fisher(data, mean, covariance, prior);
                    save(strcat(destination_dir,'/',subject{subj_i},sequence{seq_i}),'encoding','-v7.3')
                    
                else
                    % Show Warning if codebook is nit computed
                    fprintf('WARNING: Mean or covariance or Prior file not found.');
                    return;
                end
                
                clear 'encoding';  clear 'data'; clear 'mean'; clear 'covariance', clear 'prior'; clear 'destination_dir';
                
            end
            
        end
        
        clear 'HOG';  clear 'MBHx'; clear 'MBHy';
        clear 'HOG_pca'; clear 'MBHx_pca'; clear 'MBHy_pca';
        clear 'traj_desc_cmplt';
        
    end
end
%end
fprintf('++++++++++++++++++++++++++++++++++++++++++++ Feature Encoding Finished Successfuly ++++++++++++++++++++++++++++++++++++++++++++ \n');

