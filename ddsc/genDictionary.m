function [ reconDic, disaggDic ] = genDictionary( file, start, len, width, dicWidth)
disp('gendic')
t=  tic;
%agg = reshape(loadSignal(file, {'"use"'}, start, len*width), len, width);

[disagg, dataNames] = createDictionary(file, start, len, width, {'"use"', '"gen"', '"grid"'}, false, 2);
classes = size(dataNames,1);

agg = zeros(len, width);
for i = 1:width
    ind = width*(0:(classes-1))+i;
    agg(:,i) = sum(disagg(:,ind), 2);
end

[reconAct, reconDic] = pretrainDDSC(disagg, width, dicWidth);

[disaggAct, disaggDic] = trainDDSC(agg, classes, reconAct, reconDic, dicWidth);
toc(t)
end

