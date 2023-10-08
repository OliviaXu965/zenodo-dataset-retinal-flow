function matched = match_vert(target_height_img,img1)

%%


img1 = imresize(img1,size(target_height_img,2)/size(img1,2));



spacer = 255*ones(size(target_height_img,1)-size(img1,1),size(img1,2),3);

matched = [spacer;img1];
