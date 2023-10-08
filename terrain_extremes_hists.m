close all
clearvars

cfg = config();
load([cfg.dataPath '/lookup_table.mat']);



gaze = vertcat(lookup_table{:,2});
gaze = normr(gaze);
% gaze = gaze(:,[3 2 1]);
head_trans_vec = vertcat(lookup_table{:,3});
head_trans_vec = normr(head_trans_vec);

about_y = angdiff(atan2(gaze(:,3),gaze(:,1)),atan2(head_trans_vec(:,3),head_trans_vec(:,1)));

about_y = rad2deg(about_y);

rel_grav = 2*atan2(vecnorm(gaze-[0 -1 0],2,2),vecnorm(gaze+[0 -1 0],2,2));
rel_grav = rad2deg(rel_grav);

replace_dex=  strcmp(lookup_table(:,5),'rocks');

lookup_table(replace_dex,5)={'Rocks'};

terrain_types = {'Rocks','medium','bark','flat','pavement'};

[counts,xEdges,yEdges]=histcounts2(rel_grav,about_y);

grav_cens = (xEdges(2)-xEdges(1))/2 + xEdges(1:end-1);
about_cens = (yEdges(2)-yEdges(1))/2 + yEdges(1:end-1);

[grav_cens_bins,about_cens_bins] = meshgrid(grav_cens,about_cens);


[xx,yy] = meshgrid(1:250,1:250);
xx = xx-250/2;
yy = yy-250/2;

d = sqrt(xx.^2+yy.^2);

deg_radius = 10;

deg_rad_dims = 15;

mask = d<(deg_radius/45*(250/2));




%%
fig_track = 0;
bins = linspace(0,40,20);

inds_array(1,:) = [1 24];
inds_array(2,:) = [20 1];
inds_array(3,:) = [20 16];
inds_array(4,:) = [20 8];
inds_array(5,:) = [20 24];

%%


drawColors = [0,0,0;...
    230, 159, 0;...
    86, 180, 233;...
    0, 158, 115;...
    213, 94, 0]/255;


for terrain_idx = [1 length(terrain_types)-1]
    
    these_idx = strcmp(lookup_table(:,5),terrain_types{terrain_idx});
    
    
    %% match
    
    
    these_idx = find(these_idx);
    
    these_grav = rel_grav(these_idx);
    these_about = about_y(these_idx);
    
    bin_idx = knnsearch([grav_cens_bins(:) about_cens_bins(:)],[these_grav these_about]);
    [counts,xEdges,yEdges]=histcounts2(rel_grav,about_y);
    
    these_counts = counts(bin_idx);
    these_idx = randsample(these_idx,5000,true,these_counts);
    
    if terrain_idx==1
        if exist(['figureDataSources/rocks.mat'])~=2
            
            computeHistAllFromIdx(lookup_table,these_idx,['figureDataSources/rocks.mat']);
        end

    else
        if exist(['figureDataSources/flat.mat'])~=2
            
            computeHistAllFromIdx(lookup_table,these_idx,['figureDataSources/flat.mat']);
        end
    end
end
