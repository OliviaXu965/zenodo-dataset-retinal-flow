function img_out = assembleVert()

%% left
base_path = 'autogen_figs/sub_figs/vert_ang/';

left_speed_map = imread([base_path 'left_speed_map.png']);
left_speed_dist = imread([base_path 'left_speed_dists.png']);
left_dir_map = imread([base_path 'left_dir_map.png']);
left_dir_dist = imread([base_path 'left_dir_dists.png']);




lr = imread([base_path 'left_right_dir_dists.png']);
lr = imresize(lr,size(left_dir_dist,2)/size(lr,2));

dude_img = imread('figureDataSources/vert_ang_cartoon.png');

best_height = max([size(left_speed_map,1),size(left_speed_dist,1),...
    size(left_dir_map,1),size(left_dir_dist,1)]);

left_speed_map = imresize(left_speed_map,best_height/size(left_speed_map,1));
left_speed_dist = imresize(left_speed_dist,best_height/size(left_speed_dist,1));
left_dir_map = imresize(left_dir_map,best_height/size(left_dir_map,1));
left_dir_dist = imresize(left_dir_dist,best_height/size(left_dir_dist,1));

right_speed_map = imread([base_path 'right_speed_map.png']);
right_speed_map = imresize(right_speed_map,size(left_speed_map,1,2));

right_speed_dist = imread([base_path 'right_speed_dists.png']);
right_speed_dist = match_vert(left_speed_dist,right_speed_dist);

right_dir_map = imread([base_path 'right_dir_map.png']);
right_dir_map = match_vert(left_dir_map,right_dir_map);

right_dir_dist = imread([base_path 'right_dir_dists.png']);
right_dir_dist = match_vert(left_dir_dist,right_dir_dist);

lr = imresize(lr,best_height/size(lr,1));


size_diff=(size(left_dir_map,2)-size(dude_img,2));
dude_img = pad_white(dude_img,floor(size_diff/2),'left');
dude_img = pad_white(dude_img,ceil(size_diff/2),'right');


size_diff=best_height*2-size(dude_img,1);
dude_img = pad_white(dude_img,floor(size_diff/2),'top');
dude_img = pad_white(dude_img,ceil(size_diff/2),'bottom');


size_diff=best_height*2-size(lr,1);
lr = pad_white(lr,floor(size_diff/2),'top');
lr = pad_white(lr,ceil(size_diff/2),'bottom');

top_row = [dude_img [left_speed_map;right_speed_map] [left_speed_dist;right_speed_dist]];
bottom_row = [[left_dir_map;right_dir_map] [left_dir_dist;right_dir_dist] lr];

while (size(bottom_row,2)~=size(top_row,2))
    bottom_row = imresize(bottom_row,size(top_row,2)/size(bottom_row,2));
end

img_out = [top_row;bottom_row];
end

