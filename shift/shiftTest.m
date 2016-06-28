clc;
close all;

%{
%downsample example
file = 'data/id26_year.csv';
[dic, dataNames] = createDictionary(file, 0, 300, 1,{},false, 2);
ddic = downSampleDic(dic, 15);
exportCSV('data/id26_down15.csv', dataNames, ddic);
%}


file = 'data/id26_down10.csv';
dataLength = 144*1;
dicStart = dataLength * 50 + 1;
dicWidth =40;
shiftLim = 15;

[dic, dataNames] = createDictionary(file, dicStart, dataLength, dicWidth, {'"use"', '"gen"', '"grid"', '"oven2"', '"disposal1"', '"venthood1"'}, false, 0);
ndic = normalizeDic(dic);

%sparsityList = [.03, .1, .7];
%energyList = [ .01, .05, .1, .5];
%.1, .1?
sparsityList = [.1];
energyList = [.1];

numDays = 1;
maxIter = 15;
errorBar = .1;

resultErrors = zeros(3, length(sparsityList), length(energyList), numDays);
for day = 1:numDays
    sigStart = dataLength * day + 1;
    [disagg, ~] = createDictionary(file, sigStart, dataLength, 1, {'"use"', '"gen"', '"grid"', '"oven2"', '"disposal1"', '"venthood1"'}, false, 0);
    agg = sum(disagg, 2);
    fprintf('Day:  %d', day);
    for i = 1:length(sparsityList)
        for j = 1:length(energyList)
            fprintf('.');
            coeff = shiftFactor(sig, dic, length(dataNames), shiftLim, maxIter, errorBar, sparsityList(i), energyList(j), 12);
            [reconAgg, reconDisagg, e1, e2, e3] = reconstructDisagg(ndic, coeff, agg, disagg, dicWidth);
            resultErrors(:,i,j, day) = resultErrors(:,i,j, day) + [e1, e2, e3]';
        end
    end
    fprintf('\n');
end
resultErrors = shiftdim(resultErrors,1);

%coeff = shiftFactor(sig, dic, length(dataNames), shiftLim, 15, 1, .1, .0007, 12);
plotReconstructed(agg, reconAgg, disagg, reconDisagg, dataNames)

