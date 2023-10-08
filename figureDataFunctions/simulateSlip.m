function simulateSlip()


velThresh = 65;
accThresh = 5;

gridRes = 21;

ecc = 45;

[ret_xx,ret_yy] = meshgrid(1:gridRes,1:gridRes);

ret_xx = ret_xx-(size(ret_xx,1)-1)/2-1;
ret_yy = ret_yy-(size(ret_xx,1)-1)/2-1;


D = sqrt(ret_xx.^2+ret_yy.^2);

D = D/((gridRes-1)/2);
rho = D*ecc;
theta = atan2(ret_yy,ret_xx);
cutoff_mask = D<1;


zz = cosd(rho);
xx = sind(rho).*cos(theta);
yy = sind(rho).*sin(theta);

flowPreGrid = cat(3,xx,yy,zz);

flowPre = reshape(flowPreGrid,[size(xx,1)*size(xx,2) 3]);
flowPre = normr(flowPre);




fr_idx = 753;

    
               
        
        
        
        
        
        
            thisWalk = load('sample_trial.mat').thisWalk;
            
            headXYZ = thisWalk.headXYZ;
            gazeXYZ = mean(cat(3,thisWalk.lGazeGroundIntersection,thisWalk.rGazeGroundIntersection),3);
            
             
            wfi = thisWalk.worldFrameIndex;
            [u_wfi,~,ic] = unique(wfi);
            
            clear headXYZ_ds gazeXYZ_ds
            for dim = 1:3
                headXYZ_ds(:,dim) = accumarray(ic,headXYZ(:,dim),[],@mean);
                gazeXYZ_ds(:,dim) = accumarray(ic,gazeXYZ(:,dim),[],@mean);
            end
            
            headXYZ_ds(:,[1 3]) = headXYZ_ds(:,[3 1]);
            gazeXYZ_ds(:,[1 3]) = gazeXYZ_ds(:,[3 1]);
            
            headXYZ_ds(:,2) = -headXYZ_ds(:,2);
            gazeXYZ_ds(:,2) = -gazeXYZ_ds(:,2);
     
  
            head = headXYZ_ds(fr_idx,:);
            headTrans = headXYZ_ds(fr_idx+1,:)-headXYZ_ds(fr_idx,:);
            %
            %
            gaze = gazeXYZ_ds(fr_idx,:);
            eye_vec_pre = normr(gaze-head);
            %
            height = gaze(2)-head(2);
            
            
            perf_fix_loc = normr(gaze-headTrans-head);
            
            this_theta = rad2deg(acos(dot(perf_fix_loc,eye_vec_pre)));
            this_slip = this_theta*30;
            
            
            dps_slip  = 0.8*4;
            
            gain = (this_slip-dps_slip)/this_slip;
            
            eye_vec_post = normr(gaze-headTrans*gain-head);
            %                     eye_vec_post = normr(gaze-headTrans-head);
            
            
            side_vec_pre = normr(cross(eye_vec_pre,[0 -1 0]));
            up_vec_pre = normr(cross(eye_vec_pre,side_vec_pre));
            
            side_vec_post = normr(cross(eye_vec_post,[0 -1 0]));
            up_vec_post = normr(cross(eye_vec_post,side_vec_post));
            
            rotm_pre = [side_vec_pre' up_vec_pre' eye_vec_pre'];
            rotm_post = [side_vec_post' up_vec_post' eye_vec_post'];
            
            
            
            
            
            thisFlowPre = flowPre*rotm_pre';
            scaleFac = height./thisFlowPre(:,2);
            scaleFac(scaleFac<0)=nan;
            thisFlowPrePoints = scaleFac.*thisFlowPre;
            %                     thisFlowPostPoints = thisFlowPrePoints;
            thisFlowPostPoints = thisFlowPrePoints-headTrans;
            
            thisFlowPost = normr(thisFlowPostPoints);
            thisFlowPost = thisFlowPost*rotm_post;
            
            
            dTheta = 2*atan2(vecnorm(flowPre-thisFlowPost,2,2),...
                vecnorm(flowPre+thisFlowPost,2,2));
            
            dps = rad2deg(dTheta)*30;
            
            
            
            this_vel_grid = reshape(dps,size(rho));
            
            [this_dx,this_dy] = get_dx_dy(flowPre,thisFlowPost,ecc,((gridRes-1)/2));
            
            cutoff_dex = vecnorm(thisFlowPostPoints,2,2)>height*5|thisFlowPre(:,2)<0.1;
            
            this_vel_grid(cutoff_dex)=nan;
            %
            %                     this_dx(cutoff_dex)=nan;
            %                     this_dy(cutoff_dex)=nan;
            
            dx = reshape(this_dx,size(rho));
            dy = reshape(this_dy,size(rho));
            
            dx= imgaussfilt(dx,2);
            dy= imgaussfilt(dy,2);
            
      
            dx(~cutoff_mask)=nan;
            dy(~cutoff_mask)=nan;
            flow = opticalFlow(dx,dy);
            
            sacc_flow = flow;
            sacc_vel = this_vel_grid;
            
            %%
            
            head = headXYZ_ds(fr_idx,:);
            headTrans = headXYZ_ds(fr_idx+1,:)-headXYZ_ds(fr_idx,:);
            %
            %
            gaze = gazeXYZ_ds(fr_idx,:);
            eye_vec_pre = normr(gaze-head);
            %
            height = gaze(2)-head(2);
            
            %                     eye_vec_post = normr(gazeXYZ_ds(fr_idx+1,:)-head);
            eye_vec_post = normr(gaze-headTrans-head);
            
            
            side_vec_pre = normr(cross(eye_vec_pre,[0 -1 0]));
            up_vec_pre = normr(cross(eye_vec_pre,side_vec_pre));
            
            side_vec_post = normr(cross(eye_vec_post,[0 -1 0]));
            up_vec_post = normr(cross(eye_vec_post,side_vec_post));
            
            rotm_pre = [side_vec_pre' up_vec_pre' eye_vec_pre'];
            rotm_post = [side_vec_post' up_vec_post' eye_vec_post'];
            
            
            
            
            
            thisFlowPre = flowPre*rotm_pre';
            scaleFac = height./thisFlowPre(:,2);
            scaleFac(scaleFac<0)=nan;
            thisFlowPrePoints = scaleFac.*thisFlowPre;
            %                     thisFlowPostPoints = thisFlowPrePoints;
            thisFlowPostPoints = thisFlowPrePoints-headTrans;
            
            %                     cutoff_dex = vecnorm(thisFlowPostPoints,2,2)>height*5|thisFlowPre(:,2)<0.1;
            thisFlowPost = normr(thisFlowPostPoints);
            thisFlowPost = thisFlowPost*rotm_post;
            
            
            dTheta = 2*atan2(vecnorm(flowPre-thisFlowPost,2,2),...
                vecnorm(flowPre+thisFlowPost,2,2));
            
            dps = rad2deg(dTheta)*30;
            
            
            
            this_vel_grid = reshape(dps,size(rho));
            
            [this_dx,this_dy] = get_dx_dy(flowPre,thisFlowPost,ecc,((gridRes-1)/2));
            
            cutoff_dex = vecnorm(thisFlowPostPoints,2,2)>height*5|thisFlowPre(:,2)<0.1;
            
            this_vel_grid(cutoff_dex)=nan;
            
            %                     this_dx(cutoff_dex)=nan;
            %                     this_dy(cutoff_dex)=nan;
            
            dx = reshape(this_dx,size(rho));
            dy = reshape(this_dy,size(rho));
            
            dx= imgaussfilt(dx,2);
            dy= imgaussfilt(dy,2);
            
            %
            
            dx(~cutoff_mask)=nan;
            dy(~cutoff_mask)=nan;
           
            flow = opticalFlow(dx,dy);
            
            
          
            subplot(3,2,1)
            plot(flow,'scale',20);
            axis ij
           
            title('Flow Field (Stabilized)');
            line([1 21],[11 11],'color','k','linewidth',2);
            line([11 11],[1 21],'color','k','linewidth',2);
            axis equal
             xlim([1 21]);
            ylim([1 21]);
            subplot(3,2,3)
            plot(sacc_flow,'scale',20);
            axis ij;
            
            title('Flow Field (Slip)');
             line([1 21],[11 11],'color','k','linewidth',2);
            line([11 11],[1 21],'color','k','linewidth',2);
            axis equal
            xlim([1 21]);
            ylim([1 21]);
            subplot(3,2,2)
            %                    imagesc(this_vel_grid);
            surf(this_vel_grid)
            zlim([0 25]);
            ax = gca;
            colormap(ax,ones(1,3));
            %             colorbar
            title('Velocity (Stabilized)');
            
            
            
            subplot(3,2,4)
            %                     imagesc(sacc_vel);
            surf(sacc_vel);
            ax = gca;
            %             colormap(ax,'parula');
            colormap(ax,ones(1,3));
            
            %             colorbar
            title('Velocity (Slip)');
            
            
            for zz = [2,4]
                subplot(3,2,zz);
                ca = gca;
%                 ca.XTick = [1 6 11 16 21];
%                 ca.YTick = [1 6 11 16 21];
%                 ca.XTickLabel = {'-45','-22.5','0','22.5','45'};
%                 ca.YTickLabel = {'-45','-22.5','0','22.5','45'};
%                 ca.FontSize=12;
                xlabel('Horizontal angle (deg)');
                ylabel('Vertical angle (deg)');
            end
            cf = gcf;
            cf.Position = [124    53   864   836];
            
            for ee = 1:4
                subplot(3,2,ee);
                ca = gca;
                ca.XTick = [1 6 11 16 21];
                ca.YTick = [1 6 11 16 21];
                ca.XTickLabel = {'-45','-22.5','0','22.5','45'};
                ca.YTickLabel = {'-45','-22.5','0','22.5','45'};
                
            end
            
            subplot(3,2,2)
             xlabel('Horizontal');
            ylabel('Vertical');
            zlabel('Velocity (deg/s)');
            
            subplot(3,2,4)
             xlabel('Horizontal');
            ylabel('Vertical');
            zlabel('Velocity (deg/s)');
                  
            
            subplot(3,2,6)
            surf(sacc_vel-this_vel_grid);
            title('Velocity difference');
            ca = gca;
            ca.XTick = [1 6 11 16 21];
            ca.YTick = [1 6 11 16 21];
            ca.XTickLabel = {'-45','-22.5','0','22.5','45'};
            ca.YTickLabel = {'-45','-22.5','0','22.5','45'};
            colorbar('southoutside');
            ca.Position(4) = ca.Position(4)*1.1;
%                 ca
            
            
     
            saveas(gcf,[num2str(dps_slip) '_dps_slip_revision_overhead_diff.png']);
