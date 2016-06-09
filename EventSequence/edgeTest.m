%test event finding on ICU data
%http://www.ices.cmu.edu/psii/nilm/abstracts/lai_Samsung_NILM2012_abstract.pdf
%https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption
clc;

startTime = 0;
runTime = 24*60*4;
[ timeMat, dataMat ] = parseUCI('household_power_consumption.txt', startTime,runTime);
averagePower = mean(dataMat(1,:));
minPower= min(dataMat(1,:));
[eventTime, eventMag] = findEvents(dataMat(1,:), .1, true);

figure(1)
plot(dataMat(1,:)-minPower); hold on;
scatter(eventTime, dataMat(1,eventTime));

