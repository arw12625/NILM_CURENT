%find event sequences on ICU data
clc;

startTime = 1875;
runTime = 3500;
[ timeMat, dataMat ] = parseICU('household_power_consumption.txt', startTime,runTime);

sequences = findEventSequence(dataMat(1,:), .015, 20);

values = [];
for i = 1:length(sequences)
tmp = sequences{i};
values = [values, tmp(2,:)];
end


figure(1)
plot(dataMat(1,:)); hold on;
figure(2)
scatter(values, zeros(1,length(values)));