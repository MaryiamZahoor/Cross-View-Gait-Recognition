clc;
clear all;
close all;

% Root directory containing the video sequences
% This folder must have 'videos' and 'Trajectories' folders.
% The trajetories and motion descriptors will be saved into 'Trajectories' folder.
root_dir = './CASIAB/';

% Subject name in the database (Actually these are folders names)
%subject = {'fyc','hy','ljg','lqf','lsl','ml','nhz','rj','syj','wl','wq','wyc','xch','xxj','yjf','zc','zdx','zjg','zl','zyf'};
subject={'001','002','003','004','005','006','007','008','009','010','011','012','013','014',	'015',	'016',	'017',	'018',	'019',	'020',	'021',	'022',	'023',	'024',	'025',	'026',	'027',	'028','029',	'030',	'031',	'032',	'033',	'034',	'035',	'036',	'037',	'038',	'039',	'040',	'041',	'042',	'043',	'044',	'045',	'046',	'047',	'048',	'049',	'050',	'051',	'052',	'053',	'054',	'055',	'056',	'057',	'058',	'059',	'060',	'061',	'062',	'063',	'064',	'065',	'066',	'067',	'068',	'069',	'070',	'071',	'072',	'073',	'074',	'075',	'076',	'077',	'078',	'079',	'080',	'081',	'082',	'083',	'084',	'085',	'086',	'087',	'088',	'089',	'090',	'091',	'092',	'093',	'094',	'095',	'096',	'097',	'098',	'099','100','101','102','103','104','105','106','107','108','109','110','111','112','113','114','115','116','117','118','119','120','121','122','123','124'};
%subject={'010'};
%subject = {'101','102','103','104','105','106','107','108','109','110','111','112','113','114','115','116','117','118','119','120','121','122','123','124'}
% Viewing Angles
sequence = {'nm-01','nm-02','nm-03','nm-04','nm-05','nm-06', 'bg-01','bg-02', 'cl-01', 'cl-02'};
views={'000','018','036','054','072','090','108','126','144','162','180'};
numClusters = {256}; %{32,64,128,256,512,1024,2048};    cluster size = 128 to 256 are enough
testing_seq = 1;


%% Convert the image frames into a video
 %%images2Vid(root_dir, subject, sequence)

%% if trajectories are not already computed.
if( exist('./DenseTrackStab', 'file') ~= 2)              
     fprintf(strcat('Error: Please run make file. \n'));
     return
end
%computeDescriptors(root_dir, subject, sequence, views);

%% get Local descriptors.
[HOG_feats, MBHx_feats, MBHy_feats] =getDescriptors(root_dir, subject, sequence,views, testing_seq);

%% Codebook Generation and saving to directory
computeCodebook(root_dir, numClusters, HOG_feats, MBHx_feats, MBHy_feats);

%% Compute Fisher Vectors for each video sequence
computeFisherVector(root_dir, numClusters,  subject, sequence);

