function eyeMoveStats()

cfg = config();

all_sacc_next = [];
all_fix_next = [];


for subj = 1:11
    
    
    
    %     disp(subj)
    switch subj
        case 1
            subj_str = 'JAC';
            %             subj_str = 'JSM';
            
        case 2
            subj_str = 'JAW';
        case 3
            subj_str = 'JSM';
        case {4,5,6,7,8,9,10,11}
            subj_str = ['s' num2str(subj-1)];
    end
    loadStruct = load([cfg.dataPath '/eye_movement_data/' subj_str '.mat']);
    all_sacc_next = [all_sacc_next;loadStruct.all_sacc_next];
    all_fix_next = [all_fix_next;loadStruct.all_fix_next];
    
    theta_fix_by_subj{subj} = atan2(loadStruct.all_fix_next(:,2),loadStruct.all_fix_next(:,1));
    theta_sacc_by_subj{subj} = atan2(loadStruct.all_sacc_next(:,2),loadStruct.all_sacc_next(:,1));
    
    
end


theta_fix = atan2(all_fix_next(:,2),all_fix_next(:,1));
theta_sacc = atan2(all_sacc_next(:,2),all_sacc_next(:,1));

all_fix = all_fix_next;
all_sacc = all_sacc_next;
%%
figure(1)
clf
subplot(1,2,1)
polarhistogram(theta_fix,'normalization','probability');
title('Stabilizing eye movements');
% set(gca,'fontsize',34);

subplot(1,2,2)
polarhistogram(theta_sacc,'normalization','probability');
title('Fast eye movements');

for idx = 1:2
    subplot(1,2,idx)
    set(gca,'fontsize',34,'ThetaDir','counterclockwise');
    
end
set(gca,'fontsize',34);
set(gcf,'position',[2040          21        1657         950]);
set(gcf,'color','w');

saveas(gcf,'autogen_figs/eye_move_stats_dirs.png');


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
saveas(gcf,'autogen_figs/stabilizing_eye_mov_speed_statistics.png');
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
saveas(gcf,'autogen_figs/sacc_eye_mov_speed_statistics.png');

