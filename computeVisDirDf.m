function     vis_dir = computeVisDirDf(sourceAllHists,data_type)


% dataSource = '/home/karl/thesis/projects/writeups/motion_statistics/figures_2022/figureDataSources';
% lstruct=load([dataSource '/allHists.mat']);
% histsAll = lstruct.histsAll;
histsAll = sourceAllHists;
bin=load('bins_u.mat').bin;

for ii = 1:size(bin,1)
    for jj = 1:size(bin,2)
        bin(ii,jj).Mask = imresize(bin(ii,jj).Mask,[250 250]);
    end
end

vis_Vx = zeros(250,250);
vis_Vy = zeros(250,250);

ecc_bin_searcher=zeros(1,size(histsAll.reg_mag,2));

for ii = 1:size(histsAll.reg_mag,1)
    for jj = 1:size(histsAll.reg_mag,2)
        [vis_Vx(bin(ii,jj).Mask),vis_Vy(bin(ii,jj).Mask)] = getMeanDir(histsAll.reg_ori{ii,jj});
    end
    ecc_bin_searcher(ii) = getMean(histsAll.reg_mag{ii,jj});
    
end
% vis_Vx = imgaussfilt(vis_Vx,5);
% vis_Vy = imgaussfilt(vis_Vy,5);
vis_mag = atan2(vis_Vy,vis_Vx);
if strcmp(data_type,'deepflow')
    
    vis_mag = vis_mag(137:865,137:865);
end
% vis_mag = flipud(vis_mag);
% vis_dir = imresize(vis_mag,[250 250]);


hole_fill = imfill(vis_mag~=0,'holes');
vis_mag(hole_fill&vis_mag==0)=nan;
vis_mag = fillmissing(vis_mag,'linear');

vis_mag(vis_mag==0)=nan;
   vis_dir = vis_mag;
end
% vis_dir = imgaussfilt(vis_dir,5);