function [speed_map, speed_hists, dir_map, dir_hist] = get4PanelMeanDataSlipFixations()
dataSource = './figureDataSources';
%%
% vis_mag_df_path = [dataSource '/vis_mag_df.mat'];
% vis_dir_df_path = [dataSource '/vis_dir_df.mat'];
% if exist(vis_mag_df_path)~=2
    vis_mag = computeVisMagDf(load([dataSource '/mesh_orig_masks_saccades_hist_all_fixations.mat']).histsAll,'mesh');
%     save(vis_mag_df_path,'vis_mag');
    speed_map = vis_mag;
% else
%    speed_map=load(vis_mag_df_path).vis_mag;
% end
% if exist(vis_dir_df_path)~=2
    vis_dir = computeVisDirDf(load([dataSource '/mesh_orig_masks_saccades_hist_all_fixations.mat']).histsAll,'mesh');
%     save(vis_dir_df_path,'vis_dir');
    dir_map = vis_dir;
% else
%    dir_map=load(vis_dir_df_path).vis_dir;
% end
% lstruct=load([dataSource '/vis_mag_dir.mat']);
% speed_map = lstruct.vis_mag;
% dir_map = lstruct.vis_dir;


%%
lstruct=load([dataSource '/mesh_orig_masks_saccades_hist_all_fixations.mat']);
histsAll = lstruct.histsAll;

pooled_ori = histsAll.downquad_ori +...
    histsAll.upquad_ori+...
    histsAll.rightquad_ori+...
    histsAll.leftquad_ori;

ds_factor = 20;

pooled_ori = interp_resample(pooled_ori',length(pooled_ori)/ds_factor);
dir_hist = pooled_ori/sum(pooled_ori);

%%
foveal_mag = sum(vertcat(histsAll.reg_mag{1,:}),1);
speed_hists(:,1) = foveal_mag;
speed_hists(:,2) =  sum(vertcat(histsAll.reg_mag{10:12,16}));
speed_hists(:,3) =  sum(vertcat(histsAll.reg_mag{10:12,32}));
speed_hists(:,4) =  sum(vertcat(histsAll.reg_mag{10:12,24}));
speed_hists(:,5) =  sum(vertcat(histsAll.reg_mag{10:12,8}));
% upquad_mag
speed_hists = speed_hists./sum(speed_hists);

end


