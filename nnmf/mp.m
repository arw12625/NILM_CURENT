function [coeff, index] = mp(signal, dictionary, threshold, maxIter)
indices = 1:size(dictionary, 2);
len = length(signal);
i = 1;
index = [];
coeff = [];

mag = sqrt(sum(dictionary.^2, 1));
normDic = bsxfun(@rdivide, dictionary, mag);
normsig = signal / sqrt(sum(signal.^2));
r = normsig;
error = sqrt(sum(r.^2));
figure(2)
plot(normsig); hold on;
while error > threshold && i <= maxIter
    product = transpose(r)*normDic(:, indices);
    [t, j] = max(abs(product));
    index(i) = indices(j);
    
    coeff(i) = product(j);
    
    r = r - coeff(i) * normDic(:, index(i));
    error = sqrt(sum(r.^2));
    % plot(r);hold on;
    %indices(j) = [];
    
    i = i + 1;
    
end
plot(r)
error
coeff = coeff ./ mag(index) *sqrt(sum(signal.^2));