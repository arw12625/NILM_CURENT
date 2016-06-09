function [coeff, index] = mp(signal, dictionary, threshold, maxIter)
indices = 1:size(dictionary, 2);
len = length(signal);
i = 1;
index = [];
coeff = [];

mag = sqrt(sum(dictionary.^2, 1));
normDic = bsxfun(@rdivide, dictionary, mag);
normSig = signal / sqrt(sum(signal.^2));
r = normSig;
error = sqrt(sum(r.^2));
phi = [];
indices(mag==0)=[];

figure(99999)
plot(normSig); hold on;
while error > threshold && i <= maxIter && length(indices) > 0
    product = transpose(r)*normDic(:, indices);
    [t, j] = max(abs(product));
    index(i) = indices(j);
    
    coeff(i) = product(j);
    
    phi = [phi, normDic(:,index(i))];
    proj = phi * inv(phi' * phi)* phi';%perharps use pseudoinverse pinv
    r = normSig - proj * normSig;
    error = sqrt(sum(r.^2));
    % plot(r);hold on;
    indices(j) = [];
    
    i = i + 1;
    
end
plot(r)
error
coeff = coeff ./ mag(index) *sqrt(sum(signal.^2));