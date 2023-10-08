function [meanValX,meanValY] = getMeanDir(inputDist)
% ori_bins  = -pi:pi/256:pi;
ori_bins = linspace(-pi,pi,512);

meanValX = inputDist.*cos(ori_bins);
meanValY = inputDist.*sin(ori_bins);



meanValX = sum(meanValX)/sum(inputDist);
meanValY = sum(meanValY)/sum(inputDist);

% meanVal = atan2(-meanValY,meanValX);
