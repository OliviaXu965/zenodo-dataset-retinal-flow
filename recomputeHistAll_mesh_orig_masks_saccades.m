close all
clearvars


cfg = config();

fileList = dir([cfg.dataPath '/histograms_saccades/*.mat']);
fullpathify = @(x) [x.folder '/' x.name];
for idx = 1:length(fileList)
fileList_full{idx} = fullpathify(fileList(idx));
end
%% 
myPath = './figureDataSources/mesh_orig_masks_saccades_hist_all.mat';
histsAll =chunkedHistCombination(fileList_full);
save(myPath,'histsAll');