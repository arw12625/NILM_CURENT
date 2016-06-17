clc;
close all;
%{
file = '/data/id26_year.csv';
sig = loadSignal(file, {'"use"'}, 0, 7);
[nsig, sigMag] = normalizeSig(sig);
[dic, dataNames] = createDictionary(file, 0, 1, 1, {'"use"', '"gen"', '"grid"'}, true, 2);
[ndic, dicMag] = normalizeDic(dic);
%}


%{
file = 'data/id26_year.csv';
[dic, dataNames] = createDictionary(file, 0, 300, 1,{},false, 2);
ddic = downSampleDic(dic, 15);
exportCSV('data/id26_down15.csv', dataNames, ddic);
%}


file = 'data/id26_down5.csv';
sig = loadSignal(file, {'"use"'}, 1, 1440);
[nsig, sigMag] = normalizeSig(sig);
[dic, dataNames] = createDictionary(file, 1, 1440, 1, {'"use"', '"gen"', '"grid"'}, true, 0);
[ndic, dicMag] = normalizeDic(dic);


coeff = shiftFactor(nsig, ndic);
tmpp = zeros(size(dic, 1), 1);
for i = 1:length(dataNames)
    tmpCoeff = sparse(size(coeff,1), size(coeff, 2));
    tmpCoeff(:, i) = coeff(:,i);
    
    figure(i+7427)
    tmpp = tmpp + sigMag * shiftRecon(ndic, tmpCoeff);
    plot(sigMag * shiftRecon(ndic, tmpCoeff)); hold on;
    plot(dic(:,i));
    legend('reconstructed   ', 'original', 'Location', 'southoutside','Orientation','horizontal');
    title(dataNames(i));
end
figure(32553253)
plot(tmpp);
