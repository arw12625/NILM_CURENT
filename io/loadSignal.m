%load signal from csv
%file is file path
%signalName is the name of the data in the file
%signalStart is the day that the signal starts
%signalLength is the length in days of the signal
function [ signal ] = loadSignal( file, signalName, signalStart, signalLength )


fid = fopen(file);
pr = fgets(fid);
names = strsplit(pr,',');
fclose(fid);

index = findIndices(signalName, names) - 1;
dayTime = 24*60;

signal = csvread(file, dayTime*signalStart+1,index,...
    [dayTime*signalStart+1,index,dayTime*(signalLength + signalStart),index]);


end

