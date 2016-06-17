%load signal from csv
%file is file path
%signalName is the name of the data in the file
%signalStart is the index that the signal starts at
%signalLength is the length of the signal
function [ signal ] = loadSignal( file, signalName, signalStart, signalLength )


fid = fopen(file);
pr = fgets(fid);
names = strsplit(pr,',');
fclose(fid);

index = findIndices(signalName, names) - 1;

signal = csvread(file, signalStart+1,index,...
    [signalStart+1,index,(signalLength + signalStart),index]);


end

