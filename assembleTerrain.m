function img_out = assembleTerrain()

%% left
base_path = 'autogen_figs/sub_figs/terrains/';

left_speed_map = imread([base_path 'left_speed_map.png']);
left_speed_dist = imread([base_path 'left_speed_dists.png']);
left_dir_map = imread([base_path 'left_dir_map.png']);
left_dir_dist = imread([base_path 'left_dir_dists.png']);




lr = imread([base_path 'left_right_dir_dists.png']);
lr = imresize(lr,size(left_dir_dist,2)/size(lr,2));

% dude_img = imread('figureDataSources/vert_ang_cartoon.png');

rock_img = imread('figureDataSources/rocks.png');
flat_img = imread('figureDataSources/flat.png');




flat_img = imresize(flat_img,size(rock_img,1,2));

rock_img = imresize(rock_img,(size(rock_img,2)+200)/size(rock_img,2));
flat_img = imresize(flat_img,(size(flat_img,2)+200)/size(flat_img,2));

size_diff=300;
rock_img = pad_white(rock_img,floor(size_diff/2),'top');
rock_img = pad_white(rock_img,ceil(size_diff/2),'bottom');

size_diff=300;
flat_img = pad_white(flat_img,floor(size_diff/2),'top');
flat_img = pad_white(flat_img,ceil(size_diff/2),'bottom');

rock_img = circshift(rock_img,-103,1);
rock_img = insertText(rock_img,[365 25],'Rocks','AnchorPoint','Center','BoxColor','w','FontSize',64,'BoxOpacity',0);
flat_img = insertText(flat_img,[365 125],'Flat','AnchorPoint','Center','BoxColor','w','FontSize',64,'BoxOpacity',0);


dude_img = [rock_img;flat_img];


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

% dude_img(:) = 255;

while (size(left_speed_map,1)~=size(dude_img,1)/2)
    left_speed_map = imresize(left_speed_map,(size(dude_img,1)/2)/size(left_speed_map,1));
    right_speed_map = imresize(right_speed_map,(size(dude_img,1)/2)/size(right_speed_map,1));
end

top_row = [dude_img [left_speed_map;right_speed_map] [left_speed_dist;right_speed_dist]];
bottom_row = [[left_dir_map;right_dir_map] [left_dir_dist;right_dir_dist] lr];

bottom_row = imresize(bottom_row,size(top_row,2)/size(bottom_row,2));

img_out = [top_row;bottom_row];
end

