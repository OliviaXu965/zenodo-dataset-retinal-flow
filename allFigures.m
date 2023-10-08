close all
clearvars
addpath(genpath('figureDataFunctions'));
%% params
caxis_fixed = [0 30];

drawColors = [0,0,0;...
              230, 159, 0;...
              86, 180, 233;...
              0, 158, 115;...
              213, 94, 0]/255;

speed_bins = linspace(0,50,500);
speed_bins = interp_resample(speed_bins',100);
dir_bins = linspace(0,360,25);

%% simulate slip
figure(101)
clf
simulateSlip();
%% eye movement stats
figure(100)
clf
eyeMoveStats();

%% image slip
figure(1)
clf
imageSlip();
saveas(gcf,'autogen_figs/image_slip.png');
%% gaze angle dist
cfg = config();
load([cfg.dataPath '/lookup_table.mat']);

vec3d = vertcat(lookup_table{:,2});
grav_ang = 2*atan2(vecnorm(vec3d-[0,-1,0],2,2), vecnorm(vec3d+[0,-1,0],2,2));
sub_list = {'Rocks','medium','bark','flat','pavement'};

lookup_table(:,5) = replace(lookup_table(:,5),'rocks','Rocks');
figure(1)
clf
for idx = 1:length(sub_list)
   
    idx = strcmp(lookup_table(:,5),sub_list{idx});
    grav_angs = grav_ang(idx);
    [counts,bins]=histcounts(grav_angs,linspace(0,pi/2,40),'Normalization','probability');
    plot(rad2deg(bins(2:end)),counts,'linewidth',2);
    hold on
    
    disp(rad2deg(median(grav_angs)));
end

lh=legend(sub_list);

xlabel('Gaze angle relative to gravity (deg)');
ylabel('Probability');
set(gca,'Fontsize',16);
title('Terrain effect on vertical gaze angle');
xlim([0 90]);
set(gcf,'position',[595   184   901   686]);
set(lh,'position',[0.2006    0.6250    0.1732    0.1837]);
saveas(gcf,'autogen_figs/eye_dir_stats.png');



%% 4 panel mean mag and direction
this_fig_str = 'autogen_figs/4panel.png';

[speed_map, speed_hists, dir_map, dir_hist] = get4PanelMeanData();


speed_hists = interp_resample(speed_hists,100);
%%
figure(1)
clf
% speed map
subplot(2,2,1);
imagesc(speed_map);
hold on
contour(imgaussfilt(speed_map,5),5,'linewidth',3,'color','k');
colorbar
caxis(caxis_fixed);
setRetLims(gca);
h=colorbar;
ylabel(h,'Speed (deg/s)');
set(h,'Position',[0.4018    0.5835    0.0126    0.3413]);
overlaySampleLocations();
title('Average speed map');
set(gca,'fontsize',22);

% speed distributions
subplot(2,2,2);
plot(speed_bins,speed_hists(:,1),'linewidth',2,'color',drawColors(1,:));
hold on
for idx = 2:5
   plot(speed_bins,speed_hists(:,idx),'linewidth',2,'color',drawColors(idx,:));
end
non_foveal_hists = speed_hists(:,2:5);
remapYAxis(gca,0,max(non_foveal_hists(:))*1.1,max(speed_hists(:,1))*1.1,0.8);
set(gca,'fontsize',22);
ylabel('Probability');
xlabel('Speed (deg/s)');
xlim([1 40]);
lh=legend('Foveal','Left','Right','Upper','Lower');
title(lh,{'Visual field'; 'location'});
title('Speed distributions');

% vector field
vis_flow = opticalFlow(cos(dir_map),sin(dir_map));
subplot(2,2,3);
plot(vis_flow,'decimationfactor',[10 10],'scale',20);
axis ij
setRetLims(gca);
title('Average direction map');
set(gca,'fontsize',22);

% direction histogram
subplot(2,2,4);
plot(dir_bins,dir_hist/sum(dir_hist),'color','k','linewidth',2)
set(gca,'fontsize',22);
ca = gca;
ca.XTick = [0,90,180,270,360];
ylabel('Probability');
xlabel('Motion Direction (deg)');
this_ylim = ylim;
this_ylim(1) = 0;
this_ylim(2) = this_ylim(2)*1.1;
ylim(this_ylim);
title('Motion direction distribution');

set(gcf,'position',[1         266        1680         958]);
set(gcf,'color','w');
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

%% vertical angle 9 panel
this_fig_str = 'autogen_figs/vert_ang_9panel.png';
[speed_map_high, speed_hists_high, dir_map_high, dir_hist_high,...
 speed_map_low, speed_hists_low, dir_map_low, dir_hist_low] = get9PanelVertData();
bin_cens = linspace(0,360,25);

speed_hists_high = interp_resample(speed_hists_high,100);
speed_hists_low = interp_resample(speed_hists_low,100);

sp_left = [0.0931,0.2404,0.351,0.6078,0.8041]*0.8;
sp_bottom = [0.63,0.1644];
sp_width = [0.1439,0.2032,0.1798,0.01288]*0.8;
sp_height = 0.2768;

sp_bot_diff = sp_bottom(1)-sp_bottom(2);

speed_map_pos = [sp_left(1) sp_bottom(1) sp_width(1) sp_height(1)];
c_bar_pos = [sp_left(2) sp_bottom(1) sp_width(4) sp_height(1)];
speed_dist_pos = [sp_left(3) sp_bottom(1) sp_width(2) sp_height(1)];
dir_map_pos = [sp_left(4) sp_bottom(1) sp_width(1) sp_height(1)];
dir_dist_pos = [sp_left(5) sp_bottom(1) sp_width(3) sp_height(1)];
%%

% high vert speed map
% subplot(2,5,1);
%  set(gcf,'position',[-20         -27        2236         958]);

best_pos = [489          35        1002         776];

close all
c_bar_pos=[0.837845069112078,0.109185441941075,0.047763786976483,0.814945580589252];
this_fig_str='autogen_figs/sub_figs/vert_ang/left_speed_map.png';
figure(3)
clf
% high vert speed map
% subplot('position',speed_map_pos);
imagesc(speed_map_high);
hold on
contour(imgaussfilt(speed_map_high,5),'linewidth',3,'color','k');
colorbar
caxis(caxis_fixed);
setRetLims(gca);
h=colorbar;
ylabel(h,'Speed (deg/s)');
set(h,'Position',c_bar_pos);
set(gcf,'position',best_pos);
title('59.26 to 89.67 deg');
overlaySampleLocations();
set(gcf,'color','w');
set(gca,'position',[0.1300    0.1100    0.7750    0.8150]);
set(gca,'fontsize',34);
xlabel('')
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% high vert speed distributions
this_fig_str='autogen_figs/sub_figs/vert_ang/left_speed_dists.png';
figure(4)
clf
plot(speed_bins,speed_hists_high(:,1),'linewidth',2,'color',drawColors(1,:));
hold on
for idx = 2:5
   plot(speed_bins,speed_hists_high(:,idx),'linewidth',2,'color',drawColors(idx,:));
end
non_foveal_hists = speed_hists_high(:,2:5);
remapYAxis(gca,0,max(non_foveal_hists(:))*1.1,0.1,0.8);
set(gca,'FontSize',16);
ylabel('Probability');
xlabel('Speed (deg/s)');
legend('Foveal','Left','Right','Upper','Lower');
title('Speed distributions');
set(gcf,'color','w');
set(gcf,'position',best_pos);
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

%left dir vis
this_fig_str='autogen_figs/sub_figs/vert_ang/left_dir_map.png';
figure(5)
clf
vis_flow = opticalFlow(cos(dir_map_high),sin(dir_map_high));
% subplot(2,5,3);
plot(vis_flow,'decimationfactor',[10 10],'scale',20);
axis ij
setRetLims(gca);
title('Average direction map');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% left dir dist
this_fig_str='autogen_figs/sub_figs/vert_ang/left_dir_dists.png';
figure(6)
clf
% subplot(2,5,4);
% subplot('position',dir_dist_pos);
plot(dir_bins,dir_hist_high/sum(dir_hist_high),'color','k','linewidth',2)
% set(gca,'fontsize',34);
ca = gca;
ca.XTick = [0,90,180,270,360];
ylabel('Probability');
xlabel('Motion direction (deg)');
this_ylim = ylim;
this_ylim(1) = 0;
this_ylim(2) = this_ylim(2)*1.1;
ylim(this_ylim);
title('Direction distributions');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% right
this_fig_str='autogen_figs/sub_figs/vert_ang/right_speed_map.png';
figure(7)
clf
% high vert speed map
% subplot('position',speed_map_pos);
imagesc(speed_map_low);
hold on
contour(imgaussfilt(speed_map_low,5),'linewidth',3,'color','k');
colorbar
caxis(caxis_fixed);
setRetLims(gca);
h=colorbar;
ylabel(h,'Speed (deg/s)');
set(h,'Position',c_bar_pos);
set(gcf,'position',best_pos);
title('16.03 to 44.46 deg');
overlaySampleLocations();
set(gcf,'color','w');
set(gca,'position',[0.1300    0.1100    0.7750    0.8150]);
set(gca,'fontsize',34);
xlabel('')
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% high vert speed distributions
this_fig_str='autogen_figs/sub_figs/vert_ang/right_speed_dists.png';
figure(8)
clf
plot(speed_bins,speed_hists_low(:,1),'linewidth',2,'color',drawColors(1,:));
hold on
for idx = 2:5
   plot(speed_bins,speed_hists_low(:,idx),'linewidth',2,'color',drawColors(idx,:));
end
non_foveal_hists = speed_hists_low(:,2:5);
remapYAxis(gca,0,max(non_foveal_hists(:))*1.1,0.1,0.8);
set(gca,'FontSize',34);
ylabel('Probability');
xlabel('Speed (deg/s)');
legend('Foveal','Left','Right','Upper','Lower');
% title('Speed distributions');
set(gcf,'color','w');
set(gcf,'position',best_pos);
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

%left dir vis
this_fig_str='autogen_figs/sub_figs/vert_ang/right_dir_map.png';
figure(9)
clf
vis_flow = opticalFlow(cos(dir_map_low),sin(dir_map_low));
% subplot(2,5,3);
plot(vis_flow,'decimationfactor',[10 10],'scale',20);
axis ij
setRetLims(gca);
% title('Average direction map');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% left dir dist
this_fig_str='autogen_figs/sub_figs/vert_ang/right_dir_dists.png';
figure(10)
clf
% subplot(2,5,4);
% subplot('position',dir_dist_pos);
plot(dir_bins,dir_hist_low/sum(dir_hist_low),'color','k','linewidth',2)
% set(gca,'fontsize',16);
ca = gca;
ca.XTick = [0,90,180,270,360];
ylabel('Probability');
xlabel('Motion direction (deg)');
this_ylim = ylim;
this_ylim(1) = 0;
this_ylim(2) = this_ylim(2)*1.1;
ylim(this_ylim);
% title('Direction distributions');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

this_fig_str='autogen_figs/sub_figs/vert_ang/left_right_dir_dists.png';
figure(11)
clf
plot(dir_bins,dir_hist_high/sum(dir_hist_high),'color','m','linewidth',2)
hold on
plot(dir_bins,dir_hist_low/sum(dir_hist_low),'color','c','linewidth',2)
% set(gca,'fontsize',16);
ca = gca;
ca.XTick = [0,90,180,270,360];
ylabel('Probability');
xlabel('Motion direction (deg)');
this_ylim = ylim;
this_ylim(1) = 0;
this_ylim(2) = this_ylim(2)*1.1;
ylim(this_ylim);
% title('Direction distributions');
legend('Upper','Lower');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

img_out = assembleVert();



this_fig_str = 'autogen_figs/vert_ang_9panel.png';
imwrite(img_out,this_fig_str);
cropWhite(this_fig_str);
%%
% this_fig_str = 'autogen_figs/horiz_ang_9panel.png';
[speed_map_left, speed_hists_left, dir_map_left, dir_hist_left,...
 speed_map_right, speed_hists_right, dir_map_right, dir_hist_right] = get9PanelHorizData();
bin_cens = linspace(0,360,25);

speed_hists_left = interp_resample(speed_hists_left,100);
speed_hists_right = interp_resample(speed_hists_right,100);



%%
close all
c_bar_pos=[0.837845069112078,0.109185441941075,0.047763786976483,0.814945580589252];
this_fig_str='autogen_figs/sub_figs/left_speed_map.png';
figure(3)
clf
% high vert speed map
% subplot('position',speed_map_pos);
imagesc(speed_map_left);
hold on
contour(imgaussfilt(speed_map_left,5),'linewidth',3,'color','k');
colorbar
caxis(caxis_fixed);
setRetLims(gca);
h=colorbar;
ylabel(h,'Speed (deg/s)');
set(h,'Position',c_bar_pos);
set(gcf,'position',best_pos);
title('-180 to -27.5 deg');
overlaySampleLocations();
set(gcf,'color','w');
set(gca,'position',[0.1300    0.1100    0.7750    0.8150]);
set(gca,'fontsize',34);
xlabel('');
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% high vert speed distributions
this_fig_str='autogen_figs/sub_figs/left_speed_dists.png';
figure(4)
clf
plot(speed_bins,speed_hists_left(:,1),'linewidth',2,'color',drawColors(1,:));
hold on
for idx = 2:5
   plot(speed_bins,speed_hists_left(:,idx),'linewidth',2,'color',drawColors(idx,:));
end
non_foveal_hists = speed_hists_left(:,2:5);
remapYAxis(gca,0,max(non_foveal_hists(:))*1.1,0.1,0.8);
set(gca,'FontSize',16);
ylabel('Probability');
xlabel('Speed (deg/s)');
legend('Foveal','Left','Right','Upper','Lower');
title('Speed distributions');
set(gcf,'color','w');
set(gcf,'position',best_pos);
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

%left dir vis
this_fig_str='autogen_figs/sub_figs/left_dir_map.png';
figure(5)
clf
vis_flow = opticalFlow(cos(dir_map_left),sin(dir_map_left));
% subplot(2,5,3);
plot(vis_flow,'decimationfactor',[10 10],'scale',20);
axis ij
setRetLims(gca);
title('Average direction map');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% left dir dist
this_fig_str='autogen_figs/sub_figs/left_dir_dists.png';
figure(6)
clf
% subplot(2,5,4);
% subplot('position',dir_dist_pos);
plot(dir_bins,dir_hist_left/sum(dir_hist_left),'color','k','linewidth',2)
set(gca,'fontsize',16);
ca = gca;
ca.XTick = [0,90,180,270,360];
ylabel('Probability');
xlabel('Motion direction (deg)');
this_ylim = ylim;
this_ylim(1) = 0;
this_ylim(2) = this_ylim(2)*1.1;
ylim(this_ylim);
title('Direction distributions');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% right
this_fig_str='autogen_figs/sub_figs/right_speed_map.png';
figure(7)
clf
% high vert speed map
% subplot('position',speed_map_pos);
imagesc(speed_map_right);
hold on
contour(imgaussfilt(speed_map_right,5),'linewidth',3,'color','k');
colorbar
caxis(caxis_fixed);
setRetLims(gca);
h=colorbar;
ylabel(h,'Speed (deg/s)');
set(h,'Position',c_bar_pos);
set(gcf,'position',best_pos);
title('28.6 to 180 deg');
overlaySampleLocations();
set(gcf,'color','w');
set(gca,'position',[0.1300    0.1100    0.7750    0.8150]);
set(gca,'fontsize',34);
xlabel('');
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% high vert speed distributions
this_fig_str='autogen_figs/sub_figs/right_speed_dists.png';
figure(8)
clf
plot(speed_bins,speed_hists_right(:,1),'linewidth',2,'color',drawColors(1,:));
hold on
for idx = 2:5
   plot(speed_bins,speed_hists_right(:,idx),'linewidth',2,'color',drawColors(idx,:));
end
non_foveal_hists = speed_hists_right(:,2:5);
remapYAxis(gca,0,max(non_foveal_hists(:))*1.1,0.1,0.8);
set(gca,'FontSize',16);
ylabel('Probability');
xlabel('Speed (deg/s)');
legend('Foveal','Left','Right','Upper','Lower');
% title('Speed distributions');
set(gcf,'color','w');
set(gcf,'position',best_pos);
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

%left dir vis
this_fig_str='autogen_figs/sub_figs/right_dir_map.png';
figure(9)
clf
vis_flow = opticalFlow(cos(dir_map_right),sin(dir_map_right));
% subplot(2,5,3);
plot(vis_flow,'decimationfactor',[10 10],'scale',20);
axis ij
setRetLims(gca);
% title('Average direction map');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% left dir dist
this_fig_str='autogen_figs/sub_figs/right_dir_dists.png';
figure(10)
clf
% subplot(2,5,4);
% subplot('position',dir_dist_pos);
plot(dir_bins,dir_hist_right/sum(dir_hist_right),'color','k','linewidth',2)
set(gca,'fontsize',16);
ca = gca;
ca.XTick = [0,90,180,270,360];
ylabel('Probability');
xlabel('Motion direction (deg)');
this_ylim = ylim;
this_ylim(1) = 0;
this_ylim(2) = this_ylim(2)*1.1;
ylim(this_ylim);
% title('Direction distributions');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

this_fig_str='autogen_figs/sub_figs/left_right_dir_dists.png';
figure(11)
clf
plot(dir_bins,dir_hist_left/sum(dir_hist_left),'color','b','linewidth',2)
hold on
plot(dir_bins,dir_hist_right/sum(dir_hist_right),'color','r','linewidth',2)
set(gca,'fontsize',16);
ca = gca;
ca.XTick = [0,90,180,270,360];
ylabel('Probability');
xlabel('Motion direction (deg)');
this_ylim = ylim;
this_ylim(1) = 0;
this_ylim(2) = this_ylim(2)*1.1;
ylim(this_ylim);
% title('Direction distributions');
legend('Left','Right');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);




img_out = assembleHoriz();
% figure(100)
% clf
% imshow(img_out);

this_fig_str = 'autogen_figs/horiz_ang_9panel.png';
imwrite(img_out,this_fig_str);
cropWhite(this_fig_str);

%% terrain extreme angle 9 panel
this_fig_str = 'autogen_figs/flat_vs_rocks_9panel.png';
[speed_map_high, speed_hists_high, dir_map_high, dir_hist_high,...
 speed_map_low, speed_hists_low, dir_map_low, dir_hist_low] = get9PanelTerrainData();
bin_cens = linspace(0,360,25);

speed_hists_high = interp_resample(speed_hists_high,100);
speed_hists_low = interp_resample(speed_hists_low,100);

sp_left = [0.0931,0.2404,0.351,0.6078,0.8041]*0.8;
sp_bottom = [0.63,0.1644];
sp_width = [0.1439,0.2032,0.1798,0.01288]*0.8;
sp_height = 0.2768;

sp_bot_diff = sp_bottom(1)-sp_bottom(2);

speed_map_pos = [sp_left(1) sp_bottom(1) sp_width(1) sp_height(1)];
c_bar_pos = [sp_left(2) sp_bottom(1) sp_width(4) sp_height(1)];
speed_dist_pos = [sp_left(3) sp_bottom(1) sp_width(2) sp_height(1)];
dir_map_pos = [sp_left(4) sp_bottom(1) sp_width(1) sp_height(1)];
dir_dist_pos = [sp_left(5) sp_bottom(1) sp_width(3) sp_height(1)];
%%
close all
c_bar_pos=[0.837845069112078,0.109185441941075,0.047763786976483,0.814945580589252];
this_fig_str='autogen_figs/sub_figs/terrains/left_speed_map.png';
figure(3)
clf
% high vert speed map
% subplot('position',speed_map_pos);
imagesc(speed_map_high);
hold on
contour(imgaussfilt(speed_map_high,5),'linewidth',3,'color','k');
colorbar
caxis(caxis_fixed);
setRetLims(gca);
h=colorbar;
ylabel(h,'Speed (deg/s)');
set(h,'Position',c_bar_pos);
set(gcf,'position',best_pos);
% title('Rocks');
overlaySampleLocations();
set(gcf,'color','w');
set(gca,'position',[0.1300    0.1100    0.7750    0.8150]);
set(gca,'fontsize',34);
xlabel('');
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% high vert speed distributions
this_fig_str='autogen_figs/sub_figs/terrains/left_speed_dists.png';
figure(4)
clf
plot(speed_bins,speed_hists_high(:,1),'linewidth',2,'color',drawColors(1,:));
hold on
for idx = 2:5
   plot(speed_bins,speed_hists_high(:,idx),'linewidth',2,'color',drawColors(idx,:));
end
non_foveal_hists = speed_hists_high(:,2:5);
remapYAxis(gca,0,max(non_foveal_hists(:))*1.1,0.1,0.8);
set(gca,'FontSize',34);
ylabel('Probability');
xlabel('Speed (deg/s)');
legend('Foveal','Left','Right','Upper','Lower');
title('Speed distributions');
set(gcf,'color','w');
set(gcf,'position',best_pos);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

%left dir vis
this_fig_str='autogen_figs/sub_figs/terrains/left_dir_map.png';
figure(5)
clf
vis_flow = opticalFlow(cos(dir_map_high),sin(dir_map_high));
% subplot(2,5,3);
plot(vis_flow,'decimationfactor',[10 10],'scale',20);
axis ij
setRetLims(gca);
title('Average direction map');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% left dir dist
this_fig_str='autogen_figs/sub_figs/terrains/left_dir_dists.png';
figure(6)
clf
% subplot(2,5,4);
% subplot('position',dir_dist_pos);
plot(dir_bins,dir_hist_high/sum(dir_hist_high),'color','k','linewidth',2)
set(gca,'fontsize',34);
ca = gca;
ca.XTick = [0,90,180,270,360];
ylabel('Probability');
xlabel('Motion direction (deg)');
this_ylim = ylim;
this_ylim(1) = 0;
this_ylim(2) = this_ylim(2)*1.1;
ylim(this_ylim);
title('Direction distributions');
set(gcf,'position',best_pos);
set(gcf,'color','w');
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% right
this_fig_str='autogen_figs/sub_figs/terrains/right_speed_map.png';
figure(7)
clf
% high vert speed map
% subplot('position',speed_map_pos);
imagesc(speed_map_low);
hold on
contour(imgaussfilt(speed_map_low,5),'linewidth',3,'color','k');
colorbar
caxis(caxis_fixed);
setRetLims(gca);
h=colorbar;
ylabel(h,'Speed (deg/s)');
set(h,'Position',c_bar_pos);
set(gcf,'position',best_pos);
% title('Flat');
overlaySampleLocations();
set(gcf,'color','w');
set(gca,'position',[0.1300    0.1100    0.7750    0.8150]);
set(gca,'fontsize',34);
xlabel('');
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% high vert speed distributions
this_fig_str='autogen_figs/sub_figs/terrains/right_speed_dists.png';
figure(8)
clf
plot(speed_bins,speed_hists_low(:,1),'linewidth',2,'color',drawColors(1,:));
hold on
for idx = 2:5
   plot(speed_bins,speed_hists_low(:,idx),'linewidth',2,'color',drawColors(idx,:));
end
non_foveal_hists = speed_hists_low(:,2:5);
remapYAxis(gca,0,max(non_foveal_hists(:))*1.1,0.1,0.8);
set(gca,'FontSize',16);
ylabel('Probability');
xlabel('Speed (deg/s)');
legend('Foveal','Left','Right','Upper','Lower');
% title('Speed distributions');
set(gcf,'color','w');
set(gcf,'position',best_pos);
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

%left dir vis
this_fig_str='autogen_figs/sub_figs/terrains/right_dir_map.png';
figure(9)
clf
vis_flow = opticalFlow(cos(dir_map_low),sin(dir_map_low));
% subplot(2,5,3);
plot(vis_flow,'decimationfactor',[10 10],'scale',20);
axis ij
setRetLims(gca);
% title('Average direction map');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

% left dir dist
this_fig_str='autogen_figs/sub_figs/terrains/right_dir_dists.png';
figure(10)
clf
% subplot(2,5,4);
% subplot('position',dir_dist_pos);
plot(dir_bins,dir_hist_low/sum(dir_hist_low),'color','k','linewidth',2)
set(gca,'fontsize',16);
ca = gca;
ca.XTick = [0,90,180,270,360];
ylabel('Probability');
xlabel('Motion direction (deg)');
this_ylim = ylim;
this_ylim(1) = 0;
this_ylim(2) = this_ylim(2)*1.1;
ylim(this_ylim);
% title('Direction distributions');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

this_fig_str='autogen_figs/sub_figs/terrains/left_right_dir_dists.png';
figure(11)
clf
plot(dir_bins,dir_hist_high/sum(dir_hist_high),'color','m','linewidth',2)
hold on
plot(dir_bins,dir_hist_low/sum(dir_hist_low),'color','c','linewidth',2)
set(gca,'fontsize',16);
ca = gca;
ca.XTick = [0,90,180,270,360];
ylabel('Probability');
xlabel('Motion direction (deg)');
this_ylim = ylim;
this_ylim(1) = 0;
this_ylim(2) = this_ylim(2)*1.1;
ylim(this_ylim);
% title('Direction distributions');
legend('Rocks','Flat');
set(gcf,'position',best_pos);
set(gcf,'color','w');
set(gca,'fontsize',34);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);

img_out = assembleTerrain();



this_fig_str = 'autogen_figs/flat_vs_rocks_9panel.png';
imwrite(img_out,this_fig_str);
cropWhite(this_fig_str);

%%
[speed_hists_stabilized,speed_hists_combined,speed_hists_saccades] = getSaccadeSpeedData();

speed_hists_stabilized = interp_resample(speed_hists_stabilized,100);
speed_hists_combined = interp_resample(speed_hists_combined,100);
speed_hists_saccades = interp_resample(speed_hists_saccades,100);

this_fig_str='autogen_figs/saccade_speed_comparisons.png';
figure(104)
clf
subplot(3,1,1)
plot(speed_bins,speed_hists_stabilized(:,1),'linewidth',2,'color',drawColors(1,:));
hold on
for idx = 2:5
   plot(speed_bins,speed_hists_stabilized(:,idx),'linewidth',2,'color',drawColors(idx,:));
end
non_foveal_hists = speed_hists_stabilized(:,2:5);
% remapYAxis(gca,0,max(non_foveal_hists(:))*1.1,0.1,0.8);
ca=gca;
for idx = 1:length(ca.XTick)
   ca.XTickLabel{idx} = num2str(ca.XTick(idx)*8); 
end
set(gca,'FontSize',16);
ylabel('Probability');
xlabel('Speed (deg/s)');
legend('Foveal','Left','Right','Upper','Lower');
title('Stabilized');
set(gcf,'color','w');

subplot(3,1,2)
plot(speed_bins,speed_hists_combined(:,1),'linewidth',2,'color',drawColors(1,:));
hold on
for idx = 2:5
   plot(speed_bins,speed_hists_combined(:,idx),'linewidth',2,'color',drawColors(idx,:));
end
non_foveal_hists = speed_hists_combined(:,2:5);
% remapYAxis(gca,0,max(non_foveal_hists(:))*1.1,0.1,0.8);
set(gca,'FontSize',16);
ylabel('Probability');
xlabel('Speed (deg/s)');
legend('Foveal','Left','Right','Upper','Lower');
title('Stabilized and Saccades');
set(gcf,'color','w');
ca=gca;
for idx = 1:length(ca.XTick)
   ca.XTickLabel{idx} = num2str(ca.XTick(idx)*8); 
end

subplot(3,1,3)
plot(speed_bins,speed_hists_saccades(:,1),'linewidth',2,'color',drawColors(1,:));
hold on
for idx = 2:5
   plot(speed_bins,speed_hists_saccades(:,idx),'linewidth',2,'color',drawColors(idx,:));
end
non_foveal_hists = speed_hists_saccades(:,2:5);
% remapYAxis(gca,0,max(non_foveal_hists(:))*1.1,0.1,0.8);
set(gca,'FontSize',16);
ylabel('Probability');
xlabel('Speed (deg/s)');
legend('Foveal','Left','Right','Upper','Lower');
title('Saccades');
set(gcf,'color','w');
ca=gca;
for idx = 1:length(ca.XTick)
   ca.XTickLabel{idx} = num2str(ca.XTick(idx)*8); 
end
set(gcf,'position',[1921         289         976         960]);
saveas(gcf,this_fig_str);
cropWhite(this_fig_str);


