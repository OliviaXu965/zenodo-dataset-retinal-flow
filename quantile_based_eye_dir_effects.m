close all
clearvars

cfg = config();
load([cfg.dataPath '/lookup_table.mat']);
fileList = lookup_table(:,1);
fileList = cellfun(@(x) [cfg.dataPath '/histograms/' x(3:end)], fileList, 'UniformOutput',false);
lookup_table(:,1) = fileList;


gaze = vertcat(lookup_table{:,2});
gaze = normr(gaze);
head_trans_vec = vertcat(lookup_table{:,3});
head_trans_vec = normr(head_trans_vec);

about_y = angdiff(atan2(gaze(:,3),gaze(:,1)),atan2(head_trans_vec(:,3),head_trans_vec(:,1)));

about_y = rad2deg(about_y);

rel_grav = 2*atan2(vecnorm(gaze-[0 -1 0],2,2),vecnorm(gaze+[0 -1 0],2,2));
rel_grav = rad2deg(rel_grav);



quants=quantile(about_y,linspace(0,1,9));
about_y_range = quants;

for about_y_bin_idx = [ 1 length(about_y_range)-1]
    
    lb = about_y_range(about_y_bin_idx);
    ub = about_y_range(about_y_bin_idx+1);
    
    lb = round(lb,2);
    ub = round(ub,2);
    
    if exist(['./figureDataSources/about_y_' num2str(about_y_bin_idx) '.mat'])~=2
        
        these_idx = find(about_y>about_y_range(about_y_bin_idx)&about_y<about_y_range(about_y_bin_idx+1));
        computeHistAllFromIdx(lookup_table,these_idx,['./figureDataSources/about_y_' num2str(about_y_bin_idx) '.mat']);
    end
    
end
%%

grav_ang_range = quantile(rel_grav,[0.01 1/3 2/3 0.99]);

for grav_ang_bin_idx = 1:length(grav_ang_range)-1
    
    lb = grav_ang_range(grav_ang_bin_idx);
    ub = grav_ang_range(grav_ang_bin_idx+1);
    
    if exist(['./figureDataSources/grav_ang_' num2str(grav_ang_bin_idx) '.mat'])~=2
        
        these_idx = find(rel_grav>grav_ang_range(grav_ang_bin_idx)&rel_grav<grav_ang_range(grav_ang_bin_idx+1));
        
      
        computeHistAllFromIdx(lookup_table,these_idx,['./figureDataSources/grav_ang_' num2str(grav_ang_bin_idx) '.mat']);

       
    end
   
end