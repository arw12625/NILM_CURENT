%test event finding with generated data

clc
data = generateData([3,.5;5,.9;2,1.5;2,1;5,3.3;4,4;2,1.2;1,.5;1,2;2,2.5;1,3;2,2.5;1,3;2,2.5;1,3;2,2.5;1,3;2,1;1,1.5;2,1;1,1.5;2,1;1,1.5;5,.5]);
[eventTime, eventMag] = findEvents(data, .2, true);

figure(1)
scatter(1:length(data),data); hold on;
scatter(eventTime, eventMag);