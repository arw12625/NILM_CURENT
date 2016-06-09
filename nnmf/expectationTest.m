function [ ] = expectationTest( file, factor, signalStart, signalLen, dicStart, dicWidth )

clc;
addpath(genpath('.'));
%'../data/id26_jan.csv'
fid = fopen(file);
pr = fgets(fid)
names = strsplit(pr,',');
fclose(fid);

signal = loadSignal(file, {'"use"'}, signalStart, signalLen);

[dictionary, dataNames] = createDictionary('id26_jan.csv', dicStart, signalLen, dicWidth, {'"use"', '"gen"', '"grid"'}, true);
[testDictionary, testNames] = createDictionary('id26_jan.csv', signalStart, signalLen, 1, {'"use"', '"gen"', '"grid"'}, true);

[normSig, magSig] = normalize(signal);
[normDic, magDic] = normalizeDic(dictionary);

%perform coding
alpha = full(factor(signal, dictionary));

renorm = magSig * alpha ./magDic';
renorm(isnan(renorm)) = 0;

recon = zeros(size(testDictionary));
for i = 1:size(testDictionary, 2)
    for j = 1: dicWidth
        recon(:,i) = recon(:, i) + alpha((j-1) * length(dataNames) + i) * dictionary(:,(j-1) * length(dataNames) + i);
    end
end


for i = 1 : size(testDictionary,2)
    figure(i+678)
    plot(recon(:,i)); hold on;
    plot(testDictionary(:,i)); hold on;
    legend('reconstructed   ', 'original', 'Location', 'southoutside','Orientation','horizontal');
    title(dataNames(i));
end

end

