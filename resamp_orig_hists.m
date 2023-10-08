close all
clearvars

load('mesh_orig_masks_hist_all.mat');

histsAll.downquad_mag = mag_dist_50_to_400(histsAll.downquad_mag);
histsAll.upquad_mag = mag_dist_50_to_400(histsAll.upquad_mag);
histsAll.leftquad_mag = mag_dist_50_to_400(histsAll.leftquad_mag);
histsAll.rightquad_mag = mag_dist_50_to_400(histsAll.rightquad_mag);

%%
for ii = 1:size(histsAll.reg_mag,1)
    for jj = 1:size(histsAll.reg_mag,2)
        histsAll.reg_mag{ii,jj} = mag_dist_50_to_400(histsAll.reg_mag{ii,jj});
    end
end

for ii = 1:size(histsAll.v5_mag,1)
    for jj = 1:size(histsAll.v5_mag,2)
        histsAll.v5_mag{ii,jj} = mag_dist_50_to_400(histsAll.v5_mag{ii,jj});
    end
end

save('figureDataSources/mesh_orig_masks_hist_all_speed_400.mat','histsAll');

histsAll = incrementByStruct(histsAll,load('mesh_orig_masks_saccades_hist_all').histsAll);

save('figureDataSources/mesh_combined_masks_hist_all_speed_400.mat','histsAll');