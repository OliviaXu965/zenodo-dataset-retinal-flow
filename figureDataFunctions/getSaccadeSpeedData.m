function [speed_hists_stabilized,speed_hists_combined,speed_hists_saccades] = getSaccadeSpeedData()


%%
load('figureDataSources/mesh_orig_masks_hist_all_speed_400.mat');
foveal_mag = sum(vertcat(histsAll.reg_mag{1,:}),1);
speed_hists_high(:,1) = foveal_mag;
speed_hists_high(:,2) =  sum(vertcat(histsAll.reg_mag{10:12,16}));
speed_hists_high(:,3) =  sum(vertcat(histsAll.reg_mag{10:12,32}));
speed_hists_high(:,4) =  sum(vertcat(histsAll.reg_mag{10:12,24}));
speed_hists_high(:,5) =  sum(vertcat(histsAll.reg_mag{10:12,8}));
speed_hists_stabilized = speed_hists_high./sum(speed_hists_high);

%%
load('figureDataSources/mesh_combined_masks_hist_all_speed_400.mat');
foveal_mag = sum(vertcat(histsAll.reg_mag{1,:}),1);
speed_hists_high(:,1) = foveal_mag;
speed_hists_high(:,2) =  sum(vertcat(histsAll.reg_mag{10:12,16}));
speed_hists_high(:,3) =  sum(vertcat(histsAll.reg_mag{10:12,32}));
speed_hists_high(:,4) =  sum(vertcat(histsAll.reg_mag{10:12,24}));
speed_hists_high(:,5) =  sum(vertcat(histsAll.reg_mag{10:12,8}));
speed_hists_combined = speed_hists_high./sum(speed_hists_high);

%%
load('figureDataSources/mesh_orig_masks_saccades_hist_all.mat');
foveal_mag = sum(vertcat(histsAll.reg_mag{1,:}),1);
speed_hists_high(:,1) = foveal_mag;
speed_hists_high(:,2) =  sum(vertcat(histsAll.reg_mag{10:12,16}));
speed_hists_high(:,3) =  sum(vertcat(histsAll.reg_mag{10:12,32}));
speed_hists_high(:,4) =  sum(vertcat(histsAll.reg_mag{10:12,24}));
speed_hists_high(:,5) =  sum(vertcat(histsAll.reg_mag{10:12,8}));
speed_hists_saccades = speed_hists_high./sum(speed_hists_high);