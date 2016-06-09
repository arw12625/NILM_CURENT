%parse data from ICU data
function [ timeMat, dataMat] = parseICU( fileName, startLine, totalLines )

fid = fopen(fileName);

fgets(fid);

for i = 1:startLine-1
    fgets(fid);
end

timeForm = '%2u/%2u/%4u;%2u:%2u:%2u;';
dataForm = '%f;%f;%f;%f;%f;%f;%f';
timeNum = 6;
dataNum = 7;

len = totalLines;
timeMat = zeros(timeNum, len);
dataMat = zeros(dataNum, len);

for i = 1:len
timeMat(:, i) = fscanf(fid,timeForm, timeNum);
dataMat(:,i) = fscanf(fid,dataForm,dataNum);
end

fclose(fid);
end

