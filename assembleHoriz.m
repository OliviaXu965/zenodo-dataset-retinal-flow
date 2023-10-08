function img_out = assembleHoriz()

%% left
base_path = 'autogen_figs/sub_figs/';

left_speed_map = imread([base_path 'left_speed_map.png']);
left_speed_dist = imread([base_path 'left_speed_dists.png']);
left_dir_map = imread([base_path 'left_dir_map.png']);
left_dir_dist = imread([base_path 'left_dir_dists.png']);


right_speed_map = imread([base_path 'right_speed_map.png']);
right_speed_map = imresize(right_speed_map,size(left_speed_map,1,2));

right_speed_dist = imread([base_path 'right_speed_dists.png']);
right_speed_dist = match_vert(left_speed_dist,right_speed_dist);

right_dir_map = imread([base_path 'right_dir_map.png']);
right_dir_map = match_vert(left_dir_map,right_dir_map);

right_dir_dist = imread([base_path 'right_dir_dists.png']);
right_dir_dist = match_vert(left_dir_dist,right_dir_dist);


lr = imread([base_path 'left_right_dir_dists.png']);

dude_img = imread('figureDataSources/horiz_ang_cartoon.png');

% modifications
% left_speed_map = pad_white(left_speed_map,97,'left');
% right_speed_map = pad_white(right_speed_map,97,'left');
left_dir_map = pad_white(left_dir_map,130,'left');
right_dir_map = pad_white(right_dir_map,130,'left');


% left_speed_map = pad_white(left_speed_map,size(left_speed_dist,2)-size(left_speed_map,2),'right');
% right_speed_map = pad_white(right_speed_map,size(right_speed_dist,2)-size(right_speed_map,2),'right');
left_dir_map = pad_white(left_dir_map,size(left_speed_dist,2)-size(left_dir_map,2),'right');
right_dir_map = pad_white(right_dir_map,size(right_speed_dist,2)-size(right_dir_map,2),'right');

left_dir_dist = imresize(left_dir_dist,size(right_dir_map,2)/size(left_dir_dist,2));
right_dir_dist = imresize(right_dir_dist,size(right_dir_map,2)/size(right_dir_dist,2));


size_diff=(size(left_speed_map,1)-size(left_dir_dist,1));
left_dir_dist = pad_white(left_dir_dist,floor(size_diff/2),'top');
left_dir_dist = pad_white(left_dir_dist,ceil(size_diff/2),'bottom');

size_diff=(size(left_speed_map,1)-size(right_dir_dist,1));
right_dir_dist = pad_white(right_dir_dist,floor(size_diff/2),'top');
right_dir_dist = pad_white(right_dir_dist,ceil(size_diff/2),'bottom');


size_diff=(size(left_speed_map,1)-size(dude_img,1));
dude_img = pad_white(dude_img,floor(size_diff/2),'top');
dude_img = pad_white(dude_img,ceil(size_diff/2),'bottom');

size_diff=(size(left_speed_map,2)*2-size(dude_img,2));
dude_img = pad_white(dude_img,floor(size_diff/2),'left');
dude_img = pad_white(dude_img,ceil(size_diff/2),'right');
dude_img = flipud(dude_img);
dude_img = circshift(dude_img,20,2);


size_diff=(size(left_speed_map,2)*2-size(dude_img,2));
dude_img = pad_white(dude_img,floor(size_diff/2),'left');
dude_img = pad_white(dude_img,ceil(size_diff/2),'right');

size_diff = 2*size(left_dir_dist,2)-size(lr,2);
lr = pad_white(lr,floor(size_diff/2),'left');
lr = pad_white(lr,ceil(size_diff/2),'right');

size_diff = size(left_speed_map,2)-size(left_speed_dist,2);
left_speed_dist = pad_white(left_speed_dist,floor(size_diff/2),'left');
left_speed_dist = pad_white(left_speed_dist,ceil(size_diff/2),'right');

size_diff = size(left_speed_map,2)-size(right_speed_dist,2);
right_speed_dist = pad_white(right_speed_dist,floor(size_diff/2),'left');
right_speed_dist = pad_white(right_speed_dist,ceil(size_diff/2),'right');

left_dir_map = circshift(left_dir_map,20,2);
right_dir_map = circshift(right_dir_map,20,2);

right_side = [[left_dir_map right_dir_map];[left_dir_dist right_dir_dist];lr];

left_side = [dude_img;[left_speed_map right_speed_map];[left_speed_dist right_speed_dist]];

right_side = imresize(right_side,size(left_side,1)/size(right_side,1));
% right_side = right_side(1:end-1,:,:);

img_out = [left_side right_side];
% imshow(img_out)

end

