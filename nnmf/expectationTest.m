function [ ] = expectationTest( file, factor, signalStart, signalLen, dicStart, dicWidth )

clc;
addpath(genpath('.'));
%'../data/id26_jan.csv'
fid = fopen(file);
pr = fgets(fid)
names = strsplit(pr,',');
fclose(fid);

signal = loadSignal(file, {'"use"'}, signalStart, signalLen);

[dictionary, dataNames] = createDictionary(file, dicStart, signalLen, dicWidth, {'"use"', '"gen"', '"grid"'}, true, 2);
[testDictionary, testNames] = createDictionary(file, signalStart, signalLen, 1, {'"use"', '"gen"', '"grid"'}, true, 2);

[normSig, magSig] = normalizeSig(signal);
[normDic, magDic] = normalizeDic(dictionary);

%perform coding
alpha = full(factor(normSig, normDic));

renorm = alpha;
renorm(isnan(renorm)) = 0;

recon = zeros(size(testDictionary));
for i = 1:size(recon, 2)
    tmp = ((i-1)*dicWidth + 1):(i*dicWidth);
    recon(:, i) = normDic(:, tmp) * renorm(tmp) * magSig;
end

for i = 1 : size(testDictionary,2)
    figure(i+678)
    plot(recon(:,i)); hold on;
    plot(testDictionary(:,i)); hold on;
    legend('reconstructed   ', 'original', 'Location', 'southoutside','Orientation','horizontal');
    title(dataNames(i));
end


figure(200)
plot( normDic * alpha); hold on;
plot(normSig);
xlabel('time (min)');
ylabel('usage');
legend('reconstructed   ', 'original', 'Location', 'southoutside','Orientation','horizontal');
title('reconstruction')

sqrt(sum((normSig - normDic * alpha).^2))

end

