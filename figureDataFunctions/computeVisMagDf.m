function   vis_mag = computeVisMagDf(sourceAllHists,data_type)

% dataSource = '/home/karl/thesis/projects/writeups/motion_statistics/figures_2022/figureDataSources';
% lstruct=load([dataSource '/allHists.mat']);
histsAll = sourceAllHists;
bin=load('bins_u.mat').bin;

vis_mag = zeros(250,250);

ecc_bin_searcher=zeros(1,size(histsAll.reg_mag,2));


for ii = 1:size(bin,1)
    for jj = 1:size(bin,2)
        bin(ii,jj).Mask = imresize(bin(ii,jj).Mask,[250 250]);
    end
end

for ii = 1:size(histsAll.reg_mag,1)
    for jj = 1:size(histsAll.reg_mag,2)
        vis_mag(bin(ii,jj).Mask) = getMean(histsAll.reg_mag{ii,jj});
    end
    ecc_bin_searcher(ii) = getMean(histsAll.reg_mag{ii,jj});
end

if strcmp(data_type,'deepflow')
    vis_mag = vis_mag(137:865,137:865);
end

% vis_mag = flipud(vis_mag);
% vis_mag = imresize(vis_mag,[250 250]);

hole_fill = imfill(vis_mag~=0,'holes');
vis_mag(hole_fill&vis_mag==0)=nan;
vis_mag = fillmissing(vis_mag,'linear');

vis_mag(vis_mag==0)=nan;


