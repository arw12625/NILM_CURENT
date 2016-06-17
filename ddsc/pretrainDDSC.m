function [ activeOut, baseOut ] = pretrainDDSC(signal, baseWidth)

[normBase, baseMag] = normalizeDic(baseIn);
activeOut = zeros(size(activeIn));
baseOut = zeros(size(baseIn));

dicParam.lambda = .0001;
dicParam.pos = true;
codeParam.lambda = .0001;
codeParam.pos = true;

for i = 1:size(normBase, 2)
    index = ((i-1)*baseWidth+1):(i*baseWidth);
    sig = signal(:, i);
    baseOut(:,index) = mexTrainDL(sig, dicParam);
    activeOut(index) = mexLasso(base, sig, codeParam);
end


end

