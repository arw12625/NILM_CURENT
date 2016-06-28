function [reconAgg, reconDisagg, reconError, disaggError, energyError]...
    = reconstructDisagg(ndic, coeff, agg, disagg, dicWidth)

%displayPlots, ndic, coeff, sig, sigDic, dicWidth, dataNames

reconAgg = shiftRecon(ndic, coeff);
reconError = sum((reconAgg - agg).^2) / sum(agg.^2);
reconDisagg = zeros(size(disagg));

disaggError = 0;
energyError = 0;
num = size(disagg, 2);
for i = 1:num
    tmpCoeff = sparse(size(coeff,1), size(coeff, 2));
    index = ((i-1) * dicWidth) + (1:dicWidth);
    tmpCoeff(:, index) = coeff(:,index);
    
    reconDisagg(:,i) = shiftRecon(ndic, tmpCoeff);
    energyError = energyError + (sum(disagg(:,i)) - sum(reconDisagg(:,i)))^2;
    disaggError = disaggError + sum((disagg(:,i) - reconDisagg(:,i)).^2);
    
end
disaggError = disaggError / sum(agg.^2);
energyError = energyError / sum(agg)^2;

end