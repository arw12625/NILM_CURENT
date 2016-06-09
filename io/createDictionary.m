%create a dictionary from a csv
%first two columns are always ignored in file
%file is file path, dicStart is the day the dictionary starts
%dicLength is the length of the dictionary in days (number of rows)
%dicWidth is the number of lengths of data concatenated in the dictionary
%exceptions is a list of names of data to ignore
%addOffset adds the difference between total use and all subsignals to the dictionary

function [dictionary, dataNames] = createDictionary(file, dicStart, dicLength, dicWidth, exceptions, addOffset)

fid = fopen(file);
pr = fgets(fid);
names = strsplit(pr,',');
fclose(fid);

dayTime = 24*60;

start = 1 + dicStart * dayTime;
dataLen = dayTime * dicLength;

tableLen = length(names) - 2;

dicData = zeros(dataLen, tableLen, dicWidth);

for i = 1:dicWidth
    dicData(:, :,i) = csvread(file, start,2,...
        [start,2,start + dataLen - 1,tableLen+1]);
    start = start + dataLen;
end


if addOffset
    useIndex = findIndices({'"use"'}, names) - 2;
    useSig = dicData(:,useIndex,:);
end

dataNames = setdiff(names(3:end), exceptions);
indicesExceptions = findIndices(exceptions, names) - 2;
dicData(:,indicesExceptions,:)=[];


if addOffset
    len = size(dicData, 2);
    newData = zeros(size(dicData, 1), size(dicData, 2)+1, size(dicData, 3));
    for i =1:dicWidth
        offSig = useSig(:,i) - dicData(:,:,i) * ones(len,1);
        newData(:, :,i) = [dicData(:, :,i), offSig];
    end
    dicData = newData;
    dataNames = [dataNames, '"offset"'];
end

dictionary = reshape(dicData, [dataLen, size(dicData, 2)*dicWidth, 1]);


end

