close all
clearvars


dataFiles = dir('/home/karl/thesis/projects/motion_stats/all_paper_figures_analysis/data/*.mat');


all_fix = [];
all_sacc = [];

for idx = 1:length(dataFiles)
    
   
    loadStruct = load([dataFiles(idx).folder '/' dataFiles(idx).name]);
    
    all_fix = [all_fix;loadStruct.all_fix_next];
    all_sacc = [all_sacc;loadStruct.all_sacc_next];
end

%%

speeds = 2*atan2(vecnorm(all_fix-[0 0 1],2,2),vecnorm(all_fix+[0 0 1],2,2));
speeds = rad2deg(speeds)*120;

[speed_counts,bin_cens] = histcounts(speeds,100,'normalization','probability');

figure(1)
clf
plot(bin_cens(2:end),speed_counts,'color','k','linewidth',2);
set(gca,'fontsize',34);
set(gca,'XTick',linspace(0,100,11));
xlabel('Eye rotation speed (deg/s)');
ylabel('Probability');
title({'Eye rotation speed distribution'; 'during stabilizing eye movements'});
set(gcf,'position',[129          75        1734         885]);
set(gcf,'color','w');
% saveas(gcf,'figures/stabilizing_eye_mov_speed_statistics.png');
saveas(gcf,'figures/final/update_mar_10/stabilizing_eye_mov_speed_statistics.png');
cropWhite('figures/final/update_mar_10/stabilizing_eye_mov_speed_statistics.png');
%%


speeds = 2*atan2(vecnorm(all_sacc-[0 0 1],2,2),vecnorm(all_sacc+[0 0 1],2,2));
speeds = rad2deg(speeds)*120;

sacc_bins = linspace(65,600,30);

[speed_counts,bin_cens] = histcounts(speeds,sacc_bins,'normalization','probability');

figure(2)
clf
plot(bin_cens(2:end),speed_counts,'color','k','linewidth',2);
set(gca,'fontsize',34);
% set(gca,'XTick',linspace(0,100,11));
xlabel('Eye rotation speed (deg/s)');
ylabel('Probability');
title({'Eye rotation speed distribution';'during saccadic eye movements'});
set(gcf,'position',[129          75        1734         885]);
xlim([65 600]);
set(gcf,'color','w');
% saveas(gcf,'figures/sacc_eye_mov_speed_statistics.png');
saveas(gcf,'figures/final/update_mar_10/sacc_eye_mov_speed_statistics.png');
cropWhite('figures/final/update_mar_10/sacc_eye_mov_speed_statistics.png');