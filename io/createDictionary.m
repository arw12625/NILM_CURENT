%create a dictionary from a csv
%first two columns are always ignored in file
%file is file path, dicStart is the day the dictionary starts
%dicLength is the length of the dictionary (number of rows)
%dicWidth is the number of lengths of data concatenated in the dictionary
%exceptions is a list of names of data to ignore
%addOffset adds the difference between total use and all subsignals to the dictionary
%ignore is the number of columns to ignore in the table

function [dictionary, dataNames] = createDictionary(file, dicStart, dicLength, dicWidth, exceptions, addOffset, ignore)
disp('load dic')
t = tic;
fid = fopen(file);
pr = fgets(fid);
names = strsplit(pr,',');
names = cellfun(@strtrim ,names, 'UniformOutput',false);
fclose(fid);

start = dicStart;
tableLen = length(names) - ignore;

dicData = zeros(dicLength, tableLen, dicWidth);

for i = 1:dicWidth
    dicData(:, :,i) = csvread(file, start,ignore,...
        [start,ignore,start + dicLength - 1,tableLen-1+ignore]);
    start = start + dicLength;
end


if addOffset
    useIndex = findIndices({'"use"'}, names) - ignore;
    useSig = dicData(:,useIndex,:);
end

dataNames = removeDiff(names(1+ignore:end), exceptions);
indicesExceptions = findIndices(exceptions, names) - ignore;
dicData(:,indicesExceptions,:)=[];

numSignals = size(dicData, 2);

if addOffset
    numSignals = numSignals + 1;
    newData = zeros(dicLength, numSignals, dicWidth);
    for i =1:dicWidth
        offSig = useSig(:,i) - dicData(:,:,i) * ones(numSignals-1,1);
        newData(:, :,i) = [dicData(:, :,i), offSig];
    end
    dicData = newData;
    dataNames = [dataNames, '"offset"'];
    
end

dictionary = zeros(dicLength, numSignals * dicWidth);

for i = 1:numSignals
    dictionary(:,((i-1)*dicWidth +1):(i * dicWidth)) = dicData(:, i, :);
end
toc(t)
end

function outList = removeDiff(inList, toRemove)
outList = inList;
for i = 1:length(toRemove)
    outList(strcmp(outList, toRemove(i))) = [];
end
end




