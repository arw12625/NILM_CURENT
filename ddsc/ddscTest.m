%% clear
clc;  
close all;

%% Load Data
disp('loading data');

t=  tic;
file = 'data/id26_down10.csv';

trainStart = 289;
trainLength = 288;
trainWidth =100;
dicWidth = 100;
%[reconDic, disaggDic] = genDictionary(file, trainStart, trainLength, trainWidth, dicWidth);

%agg = reshape(loadSignal(file, {'"use"'}, start, len*width), len, width);

[disaggData, dataNames] = createDictionary(file, trainStart, trainLength, trainWidth, {'"use"', '"gen"', '"grid"'}, false, 0);
classes = size(dataNames,1);
[disaggData,~] = normalizeDic(disaggData);

trainAgg = zeros(trainLength, trainWidth);
for i = 1:trainWidth
    ind = trainWidth*(0:(classes-1))+i;
    trainAgg(:,i) = sum(disaggData(:,ind), 2);
end
toc(t);
%% pretrain dictionary
[reconAct, reconDic] = pretrainDDSC(disaggData, trainWidth, dicWidth);

%% fae
%{
close all;
dev = 12;
for i = 1:trainWidth
figure(i*3225153)
ind = (1:dicWidth) + dev*dicWidth;
reconAct(ind, i)
plot(reconDic(:, ind)* reconAct(ind, i)); hold on;
plot(disaggData(:,i+dev*trainWidth));
legend('recon', 'origi');
end
%}
%% train dictionary
[disaggAct, disaggDic] = trainDDSC(trainAgg, classes, reconAct, reconDic, dicWidth);

%% Load Signal
testStart = 1;
testLength = trainLength;
%agg = loadSignal(file, {'"use"'}, testStart, testLength);
[disagg, dataNames] = createDictionary(file, testStart, testLength, 1, {'"use"', '"gen"', '"grid"', '"oven2"'}, false, 0);

agg = sum(disagg, 2);

%% Factor Signal
disp('factor');
t = tic;
param.mode = 0;
param.lambda = 20;
param.pos = 1;
%param.K = 10;
alpha = mexLasso(agg, disaggDic, param);

recon = reconDic*alpha;
disaggRecon = disaggDic*alpha;

toc(t)
%% display figures
close all;
%{
for i = 1:10
   figure(i*513)
   ind = (i-1) * dicWidth + 1;
   plot(reconDic(:,ind)); hold on;
   plot(disaggDic(:,ind));
   legend('recon', 'disagg')
end
%}

for i = 1:size(alpha, 2)
    figure(1001+i)
    plot(agg(:,i)); hold on;
    plot(disaggRecon(:,i)); hold on;
    plot(recon(:,i)); hold on;
    legend('original', 'disag', 'recon');
end

disagError = 0;
for i = 1:size(disagg, 2)
    figure(51+i)
    plot(disagg(:, i)); hold on;
    ind = ((i-1)*dicWidth+1):(i*dicWidth);
    single = reconDic(:,ind)*alpha(ind);
    plot(single);    hold on;
    other = disaggDic(:,ind)*alpha(ind);
    plot(other);
    disagError = disagError + norm(abs(single - disagg(:,i)), 1);
    title(dataNames(i));
    legend('original', 'recon', 'disagg');
end
disagError/sum(abs(agg))
%% f