function images2Vid(root_dir, subject, seq)

fprintf('++++++++++++++++++++++++++++++++++++++++++++ Creating Video from sequence of frames ++++++++++++++++++++++++++++++++++++++++++++ \n');

for subj_i = 1 : length(subject)
    for seq_i = 1:length(seq)
            sub_dir = strcat(root_dir, 'Videos/', subject{subj_i},'/',seq{seq_i},'/');
            total_images = dir([sub_dir '*.png']);
            
            list_img = [];
            for list_i = 1 : length(total_images)
                list_img{list_i} = total_images(list_i).name;
            end
                
                    strcat(sub_dir,subject{subj_i},seq{seq_i},'.avi')
                    writerObj = VideoWriter(fullfile(strcat(sub_dir,subject{subj_i},seq{seq_i},'.avi')));
                    writerObj.FrameRate=30;
                    open(writerObj);
                    
                for img_indx = 1 : length(list_img)
                                  
                    image_name = strcat(sub_dir,list_img{img_indx});
                    image_data = imread(image_name);
                    writeVideo(writerObj, image_data);
                    
                end
                    close(writerObj);
                    %implay(fullfile(strcat(sub_dir,subject{subj_i},seq{seq_i},'.avi')));
                    %pause;
    end
end

fprintf('++++++++++++++++++++++++++++++++++++++++++++ Video Sequences are created ++++++++++++++++++++++++++++++++++++++++++++ \n');