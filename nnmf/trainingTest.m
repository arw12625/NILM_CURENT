function [] = trainingTest(file, factor, signalStart, signalLen, dicStart, dicWidth)

signal = loadSignal(file, {'"use"'}, signalStart, signalLen);

[dictionary, dataNames] = createDictionary(file, dicStart, signalLen, dicWidth, {'"use"', '"gen"', '"grid"'},true, 2);

%normalization is required for the omp algorithm
[normSig, magSig] = normalizeSig(signal);
[normDic, magDic] = normalizeDic(dictionary);

param.lambda = .000001;
param.pos = true;
%perform coding
alpha = full(factor(normSig, normDic));
error = sqrt(sum((normSig - normDic * alpha).^2))

%plot the reconstructed signal
figure(2)
plot( normDic * alpha); hold on;
plot(normSig);
xlabel('time (min)');
ylabel('normalized usage');
legend('reconstructed   ', 'original', 'Location', 'southoutside','Orientation','horizontal');
title('reconstruction')

renorm = magSig * alpha ./magDic';
renorm(isnan(renorm)) = 0;
logical((abs(renorm - 1) > .1) .* (renorm ~= 0));
sum(abs(dictionary * renorm - signal))/60

end


function data = dataByName(dic, name, dataNames)
    data = dic(:,findIndices(name, dataNames));
end
