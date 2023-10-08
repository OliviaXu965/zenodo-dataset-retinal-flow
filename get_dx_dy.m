function [dx,dy] = get_dx_dy(vecs1,vecs2,ecc,half_res)




rho_prev = 2*atan2(vecnorm(vecs1-[0 0 1],2,2),vecnorm(vecs1+[0 0 1],2,2));
rho_post = 2*atan2(vecnorm(vecs2-[0 0 1],2,2),vecnorm(vecs2+[0 0 1],2,2));

rho_prev = rho_prev/deg2rad(ecc);
rho_post = rho_post/deg2rad(ecc);

rho_prev = rho_prev*half_res;
rho_post = rho_post*half_res;


theta_prev = atan2(vecs1(:,2),vecs1(:,1));
theta_post = atan2(vecs1(:,2),vecs1(:,1));

x_prev = rho_prev.*cos(theta_prev);
y_prev = rho_prev.*sin(theta_prev);

x_post = rho_post.*cos(theta_post);
y_post = rho_post.*sin(theta_post);

dx = x_post- x_prev;
dy = y_post - y_prev;








end