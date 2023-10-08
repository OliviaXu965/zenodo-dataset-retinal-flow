function meanVal = getMean(inputDist)
speed_bins = linspace(0,50,500);

meanVal = inputDist.*speed_bins;
meanVal = sum(meanVal)/sum(inputDist);
