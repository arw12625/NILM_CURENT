function [ disagActivation, disagBase ] = trainDDSC( signal, reconActivation, reconBase )

disagBase = reconBase;
stepSize = .5;

param.lambda = .0004;
param.pos = true;
%add constraints
while ~converged
    disagActivation = mexLasso(disagBase, signal, param);
    disagBase = disagBase - stepSize * ((signal - disagBase * disagActivation)*disagActivation...
     - (signal - disagBase*reconActivation)*reconActivation');
    [disagBase, ~] = normalizeDic(disagBase);
end

end

