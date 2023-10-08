function [speed_map_high, speed_hists_high, dir_map_high, dir_hist_high,...
 speed_map_low, speed_hists_low, dir_map_low, dir_hist_low] = get9PanelHorizData()
speed_bins = linspace(0,50,251);
%%
dataSource = './figureDataSources';

histsAll = load([dataSource '/about_y_1.mat']).histsAll;

 vis_mag = computeVisMagDf(histsAll,'mesh');
 speed_map_high = vis_mag;
 
 vis_dir = computeVisDirDf(histsAll,'mesh');
 dir_map_high = vis_dir;
  
 
foveal_mag = sum(vertcat(histsAll.reg_mag{1,:}),1);
speed_hists_high(:,1) = foveal_mag;
speed_hists_high(:,2) =  sum(vertcat(histsAll.reg_mag{10:12,16}));
speed_hists_high(:,3) =  sum(vertcat(histsAll.reg_mag{10:12,32}));
speed_hists_high(:,4) =  sum(vertcat(histsAll.reg_mag{10:12,24}));
speed_hists_high(:,5) =  sum(vertcat(histsAll.reg_mag{10:12,8}));
 speed_hists_high = speed_hists_high./sum(speed_hists_high);
 
 
pooled_ori = histsAll.downquad_ori +...
    histsAll.upquad_ori+...
    histsAll.rightquad_ori+...
    histsAll.leftquad_ori;

ds_factor = 20;

pooled_ori = interp_resample(pooled_ori',length(pooled_ori)/ds_factor);
dir_hist_high = pooled_ori/sum(pooled_ori);
 
 %%
 histsAll = load([dataSource '/about_y_8.mat']).histsAll;
 
vis_mag = computeVisMagDf(histsAll,'mesh');
 speed_map_low = vis_mag;
 
 vis_dir = computeVisDirDf(histsAll,'mesh');
 dir_map_low = vis_dir;
 
 foveal_mag = sum(vertcat(histsAll.reg_mag{1,:}),1);
speed_hists_low(:,1) = foveal_mag;
speed_hists_low(:,2) =  sum(vertcat(histsAll.reg_mag{10:12,16}));
speed_hists_low(:,3) =  sum(vertcat(histsAll.reg_mag{10:12,32}));
speed_hists_low(:,4) =  sum(vertcat(histsAll.reg_mag{10:12,24}));
speed_hists_low(:,5) =  sum(vertcat(histsAll.reg_mag{10:12,8}));
 speed_hists_low = speed_hists_low./sum(speed_hists_low);
 
 
pooled_ori = histsAll.downquad_ori +...
    histsAll.upquad_ori+...
    histsAll.rightquad_ori+...
    histsAll.leftquad_ori;

ds_factor = 20;

pooled_ori = interp_resample(pooled_ori',length(pooled_ori)/ds_factor);
dir_hist_low = pooled_ori/sum(pooled_ori);




end