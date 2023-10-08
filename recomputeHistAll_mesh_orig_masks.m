close all
clearvars

cfg = config();
load([cfg.dataPath '/lookup_table.mat']);

fileList = lookup_table(:,1);
fileList = cellfun(@(x) [cfg.dataPath '/histograms/' x(3:end)], fileList, 'UniformOutput',false);
lookup_table(:,1) = fileList;
%% 
myPath = './figureDataSources/mesh_orig_masks_hist_all.mat';
these_idx = 1:length(fileList);
computeHistAllFromIdx(lookup_table,these_idx,myPath)