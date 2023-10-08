function imageSlip()

cfg = config();

load([cfg.dataPath '/fixations_in_image_space.mat']);


num_frames = [];
ang_dist = [];

final_rel = [];

rho = [];
theta = [];

gain=[];

for ii = 1:size(gaze_by_fix,1)
    angDist{ii} = [];
    fixDur{ii} = [];
    retSlip{ii} = [];
    
    for ee = 1:num_walk(ii)
        
        for ff = 1:num_fix(ii,ee)
            
            
            
            thisFix = gaze_by_fix(ii,ee,ff);
            
            
            thisRef = thisFix.stabilized;
            thisRel = thisFix.raw;
            
            thisRef = normr([thisRef - [1920/2 1080/2] 2100/2.3232*ones(size(thisRef,1),1)]);
            thisRel = normr([thisRel - [1920/2 1080/2] 2100/2.3232*ones(size(thisRel,1),1)]);
            
            thisAng = 2*atan2(vecnorm(thisRef-thisRel,2,2),vecnorm(thisRef+thisRel,2,2));
            
            num_frames = [num_frames; (1:length(thisAng))'];
            ang_dist = [ang_dist;thisAng];
            
            angDist{ii} = [angDist{ii};mean(rad2deg(thisAng(end)))];
            fixDur{ii} = [ fixDur{ii};length(thisAng)];
            retSlip{ii} = [retSlip{ii} ;rad2deg(thisAng(end))/length(thisAng)*30];
            
            final_rel = [final_rel;thisFix.stabilized(end,:)-thisFix.raw(end,:)];
            
            rho = [rho;thisAng(2:end)];
            
        end
        
    end
    
    
    
end

quantile(rad2deg(rho),[.75 .95])
figure(8)
clf
histogram(rad2deg(rho),linspace(0,4,100),'normalization','probability');
% histogram(rad2deg(rho),100,'normalization','probability');

ca = gca;
ca.FontSize=32;
xlabel('Distance from initial fixation position (Degrees)');
ylabel('Probability');
xline(median(rad2deg(rho)),'color','r','linewidth',2);
xline(.2626,'color','k','linewidth',2);
ylimz = ylim;
text(0.05+rad2deg(median(rho)),ylimz(2)*.8,num2str(rad2deg(median(rho))),'color','r','fontsize',24)
text(.3,ylimz(2)*.9,num2str(.2626),'color','k','fontsize',24)

set(gcf,'Position',get(0,'screensize').*[1 1 0.5 1]);
title('Initial fixation target slip');
