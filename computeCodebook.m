function computeCodebook(root_dir, numClusters, HOG, MBHx, MBHy)

run('lib/encoding/toolbox/vl_setup');
clc;
fprintf('++++++++++++++++++++++++++++++++++++++++++++ Computing Codebook ++++++++++++++++++++++++++++++++++++++++++++ \n');

%% Applying PCA
% no_comp = {96}; %{16,32,48,64,80,96}; Feature dimension less than 96 will effect in decline of recognition accuracy
% for no_comp_i = 1:length(no_comp)
%     no_comp_i
%     %Apply PCA
%     if(no_comp{no_comp_i} < 96)
%     [HOG_coeff,HOG_pca] = pca(HOG,'NumComponents',no_comp{no_comp_i});        
%     [MBHx_coeff,MBHx_pca] = pca(MBHx,'NumComponents',no_comp{no_comp_i});     
%     [MBHy_coeff,MBHy_pca] = pca(MBHy,'NumComponents',no_comp{no_comp_i});     
%     else
%         HOG_pca = HOG_feats;
%         MBHx_pca = MBHx_feats;
%         MBHy_pca = MBHy_feats;
%     end 
    

%% GMM Clustering on original/PCA's data
    for numClusters_i = 1:length(numClusters)
       
        [HOG_means, HOG_covariances, HOG_priors] = vl_gmm(HOG', numClusters{numClusters_i});
        [MBHx_means, MBHx_covariances, MBHx_priors] = vl_gmm(MBHx', numClusters{numClusters_i});
        [MBHy_means, MBHy_covariances, MBHy_priors] = vl_gmm(MBHy', numClusters{numClusters_i});
        
        HOG_dir = strcat(root_dir, '/HOG/',  num2str(numClusters{numClusters_i}),'/');
        MBHx_dir = strcat(root_dir, '/MBHx/',  num2str(numClusters{numClusters_i}),'/');
        MBHy_dir = strcat(root_dir, '/MBHy/',  num2str(numClusters{numClusters_i}),'/');
        
        if ( exist(HOG_dir) ~= 7) mkdir(HOG_dir); end
        if ( exist(MBHx_dir) ~= 7) mkdir(MBHx_dir); end
        if ( exist(MBHy_dir) ~= 7) mkdir(MBHy_dir); end
        
        save(strcat(HOG_dir,'HOG_mean'),'HOG_means','-v7.3');
        save(strcat(HOG_dir,'HOG_covariance'),'HOG_covariances','-v7.3');
        save(strcat(HOG_dir,'HOG_prior'),'HOG_priors','-v7.3');
        
        save(strcat(MBHx_dir,'MBHx_mean'),'MBHx_means','-v7.3');
        save(strcat(MBHx_dir,'MBHx_covariance'),'MBHx_covariances','-v7.3');
        save(strcat(MBHx_dir,'MBHx_prior'),'MBHx_priors','-v7.3');
        
        save(strcat(MBHy_dir,'MBHy_mean'),'MBHy_means','-v7.3');
        save(strcat(MBHy_dir,'MBHy_covariance'),'MBHy_covariances','-v7.3');
        save(strcat(MBHy_dir,'MBHy_prior'),'MBHy_priors','-v7.3');
        
        clear 'HOG_means'; clear 'HOG_covariances'; clear 'HOG_priors';  
        clear 'MBHx_means'; clear 'MBHx_covariances'; clear 'MBHx_priors';
        clear 'MBHy_means'; clear 'MBHy_covariances'; clear 'MBHy_priors';
        clear 'HOG_coeff';  clear 'MBHx_coeff'; clear 'MBHy_coeff';
    end
% end
% clear 'HOG_pca'; clear 'MBHx_pca'; clear 'MBHy_pca';
% clear 'HOG_feats'; clear 'MBHx_feats'; clear 'MBHy_feats';

fprintf('++++++++++++++++++++++++++++++++++++++++++++ Codenbook is computed and Saved. ++++++++++++++++++++++++++++++++++++++++++++ \n');