clc;
clear all;
close all;

file = 'data/id26_year.csv';


param.lambda = .0001;
param.pos = true;
factor = @(sig, dic) mexLasso(sig, dic, param);

%trainingTest(file,factor, 1, 1440, 1, 5);

expectationTest(file,factor, 1, 1440, 1, 1);

%plotSignals(file, 1, 1000, 5);


