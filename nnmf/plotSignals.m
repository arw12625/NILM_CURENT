function [] = plotSignals( file, signalStart, signalLen, numTrace )

[dictionary, names] = createDictionary(file, signalStart, signalLen, numTrace, {'"use"', '"gen"', '"grid"'}, true, 2);
width = length(names);
for i = 1:width
    figure(i+86432)
    for j= 1:numTrace
        plot(dictionary(:, i+(j-1)*width)); hold on;
    end
    title(names(i));
end

end

