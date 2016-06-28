function [activeOut, dicOut] = pretrainDDSC(signal, sigWidth, dicWidth)

disp('pretrain');
t = tic;
%learn sparse dictionary from disaggregated signals

[normSig, sigMag] = normalizeDic(signal);
classNumber = size(normSig, 2) / sigWidth;
activeOut = sparse(dicWidth*classNumber, sigWidth);
dicOut = zeros(size(signal, 1), dicWidth*classNumber);

%dicParam.modeD = 0;
dicParam.K = dicWidth;
dicParam.lambda = 1;
dicParam.mode = 0;
dicParam.posAlpha = 1;
dicParam.posD = 1;
dicParam.iter = 300;

%codeParam.L = 15;
codeParam.mode = 0;
codeParam.lambda = 1.1;
codeParam.pos = 1;

for i = 1:classNumber
    sigInd = ((i-1)*sigWidth+1):(i*sigWidth);
    dicInd = ((i-1)*dicWidth+1):(i*dicWidth);
    dicOut(:,dicInd) = mexTrainDL(signal(:,sigInd), dicParam);
    activeOut(dicInd, :) = mexLasso(normSig(:, sigInd), dicOut(:, dicInd), codeParam);
end
activeOut(activeOut < 0.0005) = 0;
dicOut(dicOut<0) = 0;

toc(t)

end

