function cropWhite(img_path)

this_fig_png = imread(img_path);

row_sum = sum(this_fig_png(:,:,1)==255,1);


lb = find(row_sum~=size(this_fig_png,1),1,'first');
ub = find(row_sum~=size(this_fig_png,1),1,'last');

this_fig_png = this_fig_png(:,lb:ub,:);


col_sum = sum(this_fig_png(:,:,1)==255,2);


lb = find(col_sum~=size(this_fig_png,2),1,'first');
ub = find(col_sum~=size(this_fig_png,2),1,'last');


this_fig_png = this_fig_png(lb:ub,:,:);

imwrite(this_fig_png,img_path);

end