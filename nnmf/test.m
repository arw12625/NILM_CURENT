clc;
clear all;

file = 'data/id86_jan.csv';


param.lambda = .000001;
param.pos = true;
factor = @(sig, dic) mexLasso(sig, dic, param);

trainingTest(file,factor, 0, 1, 0, 1);

%expectationTest(file,factor, 0, 1, 0, 1);