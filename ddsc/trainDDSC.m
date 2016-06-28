function [ disaggActivation, disaggDic ] = trainDDSC( agg, classes, reconActivation, reconDic, dicWidth )

disp('train')
t = tic;

disaggDic = reconDic;
stepSize = .1;

param.lambda = 50;
%param.K = 120;
param.mode = 0;
param.pos = 1;

maxIter = 10;
iter = 1;
error = realmax;
errorBar = 0.001;

while iter <= maxIter && error > errorBar
    %sparse code from the dicitonary
    disaggActivation = mexLasso(agg, disaggDic, param);
    %move dictionary towards disaggregation error minimum
    disaggDic = disaggDic - stepSize...
     *((agg - disaggDic * disaggActivation) * disaggActivation'...
     - (agg - disaggDic * reconActivation)  * reconActivation');
    %renormalize dictionary
    disaggDic = coercePositive(disaggDic);
    [disaggDic, ~] = normalizeDic(disaggDic);
    
    error = norm(agg - disaggDic * disaggActivation, 'fro');
    iter = iter + 1;
end
toc(t)
end

function outMat = coercePositive(inMat)
outMat = inMat;
outMat(inMat<0) = 0;
end
