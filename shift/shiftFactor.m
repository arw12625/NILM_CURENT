function [ coefficients ] = shiftFactor( signal, dic)

len = length(signal);
num = size(dic, 2);
aLen = len * 2 - 1;
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
gamma = .03;
errorBar = .0001;
deviceSparsity = .00005;
threshold = 0.001;
activeAddNum = 10;
maxIter = 11;
iter = 1;

err = sum((y - shiftRecon(dic, x)).^2) + gamma * sum(sum(abs(x)))

options = optimoptions('quadprog',...
    'Algorithm','interior-point-convex','Display','off');

figure(532532)
plot(signal); hold on;

while ~optimZeroCond && iter <= maxIter
    
    %the difference between the signal and the reconstruction
    difference = y - shiftRecon(dic, x);
    
    derMin = zeros(3,activeAddNum);
    derCount = 0;
    
    tmp = [];
    for(j = 1:num)
    tmp(j) = calcDer(difference, dic(:,j), 144);
    end
    tmp;
    
    for j = 1:num
        for i = 1:aLen
            %calculate the derivative and keep activeAddNum highest values
            der = calcDer(difference, dic(:,j), i);
            k = 1;
            while k <= activeAddNum && der < derMin(1,k)
                
                    k = k+1;
            end
            
            if k ~= 1 && activeSet(i, j) ~= 1
                if k > 1
                   derMin(:, 1:(k-2)) = derMin(:, 2:(k-1));
                end
                derMin(1, k-1) = der;
                derMin(2, k-1) = i;
                derMin(3, k-1) = j;
                derCount = derCount + 1;
            end
        end
    end
    derMin;
    for k = max(1, activeAddNum - derCount+1):activeAddNum
        activeSet(derMin(2, k), derMin(3, k)) = 1;
    end
    activeInd = find(activeSet);
    [activeShifts, activeSignals] = find(activeSet);
    activeLength = length(activeShifts);
    activeMat = zeros(len, activeLength);
    for i = 1:activeLength
        %make active matrix of shifted signals for quadratic programming
        activeMat(:,i) = shiftSignal(dic(:, activeSignals(i)), activeShifts(i));
    end
    
    %current coefficients
    xmod = reshape(x(activeInd), [activeLength, 1]);
    
    %compute analytic solution to unconstrained quadratic programming
    %solution = inv(matr'*matr)*(matr'*signal-gamma/2);
    %solution = (activeMat'*activeMat)\(activeMat'*signal - gamma / 2);
    quadMat = 2*(activeMat' * activeMat);
    %diagonal component to ensure positive definiteness
    quadSize = size(quadMat, 1);
    quadMat = quadMat + deviceSparsity * eye(quadSize);
    quadVec = gamma - 2* y'*activeMat;
    solution = quadprog(quadMat, quadVec, -eye(quadSize), zeros(quadSize, 1), [],[],[],[], xmod, options);
    solution';
    
    %check objective at sign changes and endpoint
    %interpolation coeff and force endpoint
    preInter = -solution./(xmod-solution);
    inter = [preInter(between(preInter, 0, 1)); 0; 1];
    %value of objective function at sign changes
    obj = zeros(1,length(inter));
    for k = 1:length(inter)
        %compute objective function at steps
        step = solution*(1-inter(k)) + xmod*inter(k);
        obj(k) = sum((y - activeMat * step).^2) + gamma * sum(abs(step));
    end
    [minObj, minInd] = min(obj);
    minObj;
    oldie = obj(end);
    newie = obj(end - 1);
    
    %set new coefficients to x
    xmod = solution*(1-inter(minInd)) + xmod*inter(minInd);
    nonPosIndices = xmod<threshold;
    xmod(nonPosIndices) = 0;
    %update active set to remove non positives
    x(find(activeSet)) = xmod;
    activeSet(nonPosIndices) = 0;
    
    err = sum((y - shiftRecon(dic, x)).^2) + gamma * sum(sum(x))
    %plot(y - shiftRecon(dic, x)); hold on;
    optimZeroCond = err < errorBar;
    iter = iter + 1;
end

figure(214214521)
plot(shiftRecon(dic, x));hold on;
plot(y);

coefficients = x

end


function der = calcDer(difference, signal, shift)

    der = -2*difference' *shiftSignal(signal, shift);

end

function bet = between(signal, lower, upper)
    bet = logical((signal < upper) .* (signal > lower));
end
