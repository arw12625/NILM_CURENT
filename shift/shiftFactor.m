function [ coefficients ] = shiftFactor( signal, dic, numSignals, shiftLim,...
    maxIter, errorBar,  sparsityParam, energyParam, activeAddNum)

len = length(signal);
num = size(dic, 2);
if shiftLim > (len - 1)
    disp('Shift longer than signal length');
    shiftLim = len-1;
end
aLen = 1 + 2*shiftLim;
coeffSize = [aLen, num];

%alias for signal
y = signal;

%the sparse matrix containing coefficients from the decomposition
allocationSize = 1000;
x = spalloc(coeffSize(1), coeffSize(2), allocationSize);
%set of relevant variables
activeSet = spalloc(coeffSize(1), coeffSize(2), allocationSize);

%stopping conditions
optimZeroCond = false;

%regularization
%sparsityParam = 0.1;
%energyParam = 0.0007;
%errorBar = 1;
diagOffset = .0000;
threshold = 0.01;
%activeAddNum = 12;
iter = 1;
dicWidth = num / numSignals;

energies = zeros(numSignals,1);
for i = 1:numSignals
    energies(i) = sum(sum(dic(:,((i-1)*dicWidth+1):(i*dicWidth)))) / dicWidth;
end


[ndic, dicMag] = normalizeDic(dic);
dicEnergies = sum(dic, 1);

options = optimoptions('quadprog',...
    'Algorithm','interior-point-convex','Display','off');

while ~optimZeroCond && iter <= maxIter
    
    %the difference between the signal and the reconstruction
    difference = y - shiftRecon(ndic, x);
     
    currentEnergies = zeros(numSignals, 1);
    [r,c,v] = find(x);
    for i = 1:length(r)
        device = floor((c(i)-1) / dicWidth)+1;
        shiftedBase = addShifted(zeros(len,1), ndic(:,c(i)), 1, r(i), shiftLim);
        currentEnergies(device) = currentEnergies(device) + sum(shiftedBase) * v(i);
    end
    
    derMin = zeros(3,numSignals);
    
    for j = 1:num
        device = floor((j-1)/dicWidth) + 1;
        for i = 1:aLen
            %calculate the derivative and keep activeAddNum highest values
            %der = calcDer(difference, ndic(:,j), i, shiftLim);
            shiftedBase = addShifted(zeros(size(signal)), ndic(:,j), 1, i, shiftLim);
            energyShifted = sum(shiftedBase);
            
            der = -2*difference' * shiftedBase...
                  - 2*energyParam*(energies(device) - currentEnergies(device))*energyShifted...
                  + sparsityParam;

            if (der < derMin(1,device)) && (activeSet(i, j) ~= 1)
                derMin(1, device) = der;
                derMin(2, device) = i;
                derMin(3, device) = j;
            end
            
        end
    end
    
    
    
    [~, sortedIndices] = sort(derMin(1,:));
    derMin = derMin(:, sortedIndices(1:activeAddNum));
    derCount = activeAddNum-sum(derMin(1,:)==0);
        
    %should change this to add all values in one step
    for k = 1:derCount
        activeSet(derMin(2, k), derMin(3, k)) = 1;
    end
    activeInd = find(activeSet);
    [activeShifts, activeSignals, activeValues] = find(activeSet);
    activeLength = length(activeShifts);
    activeMat = zeros(len, activeLength);
    activeEnergy = zeros(numSignals, activeLength);
    for i = 1:activeLength
        %make active matrix of shifted signals for quadratic programming
        shiftedSig = addShifted(activeMat(:,i), ndic(:,activeSignals(i)), 1, activeShifts(i), shiftLim);
        activeMat(:,i) = shiftedSig;
        shiftedEnergy = sum(shiftedSig);
        device = floor((activeSignals(i)-1) / dicWidth)+1;
        activeEnergy(device, i) = shiftedEnergy;
        
    end
    
    %current coefficients
    xmod = reshape(x(activeInd), [activeLength, 1]);
    
    
    
    %compute analytic solution to unconstrained quadratic programming
    %solution = inv(matr'*matr)*(matr'*signal-sparsityParam/2);
    %solution = (activeMat'*activeMat)\(activeMat'*signal - sparsityParam / 2);
    quadMat = 2*(activeMat' * activeMat + energyParam*(activeEnergy'*activeEnergy));
    %diagonal component to ensure positive definiteness
    quadSize = size(quadMat, 1);
    quadMat = quadMat + diagOffset * eye(quadSize);
    quadVec = sparsityParam - 2* (y'*activeMat +energyParam*energies'*activeEnergy);
    solution = quadprog(quadMat, quadVec, -eye(quadSize), zeros(quadSize, 1), [],[],[],[], xmod, options);
    
    
    %check objective at sign changes and endpoint
    %interpolation coeff and force endpoint
    %preInter = -solution./(xmod-solution);
    %inter = [preInter(between(preInter, 0, 1)); 0; 1];
    inter = [0; 1];
    %value of objective function at sign changes
    obj = zeros(1,length(inter));
    for k = 1:length(inter)
        %compute objective function at steps
        step = solution*(1-inter(k)) + xmod*inter(k);
        currentEnergy = zeros(numSignals, 1);
        for z = 1:length(activeSignals)
            device = floor((activeSignals(z) - 1) / dicWidth) + 1;
            currentEnergy(device) = currentEnergy(device) + activeValues(z) * dicEnergies(activeSignals(z));
        end
        obj(k) = sum((y - activeMat * step).^2) + sparsityParam * sum(step) + energyParam * sum((energies - currentEnergy).^2);
        
    end
    [minObj, minInd] = min(obj);
    
    %set new coefficients to x
    xmod = solution*(1-inter(minInd)) + xmod*inter(minInd);
    nonPosIndices = xmod<threshold;
    xmod(nonPosIndices) = 0;
    %update active set to remove non positives
    x(find(activeSet)) = xmod;
    activeSet(nonPosIndices) = 0;
    
    err = sum((y - shiftRecon(ndic, x)).^2)
    %plot(y - shiftRecon(ndic, x)); hold on;
    optimZeroCond = err < errorBar;
    iter = iter + 1;
end

coefficients = x;

end

function [diff] = calcTimeSparsityDer(x, signal, shift)
    index = (1:dicWidth) + (device-1)*dicWidth;
    [dshift,dsignal,coeff] = find(x(:,index));
    diff = 0;
    for i = 1:length(shift)
            diff = diff + coeff(i) * timeCost(dshift(i) - shift, dsignal(i) - signal);
    end
    diff = diff * 2;
end

function [cost] = timeCost(shiftDiff, sigDiff)
    if shiftDiff == 0
        if sigDiff == 0
            cost = 1;
        else 
            cost = 2;
        end
    else
        cost = 1/abs(shiftDiff)^2;
    end
end