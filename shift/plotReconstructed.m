function [] = plotReconstructed(agg, reconAgg, disagg, reconDisagg, dataNames)

%displayPlots, ndic, coeff, sig, sigDic, dicWidth, dataName
    figure(214214521)
    plot(reconAgg);hold on;
    plot(agg);
    legend('recon', 'orig');

for i = 1:length(dataNames)
        figure(i+7427)
        plot(reconDisagg(:, i), '-'); hold on;
        plot(disagg(:,i), '--');
        legend('reconstructed   ', 'original', 'Location', 'southoutside','Orientation','horizontal');
        title(dataNames(i));

end

end