function sig = shiftRecon(dic, x)
    sig = zeros(size(dic, 1), 1);
    shiftLim = (size(x, 1) - 1) / 2;
    [shift, signal, val] = find(x);
    for i = 1:length(shift)
        sig = addShifted(sig, dic(:,signal(i)), val(i), shift(i), shiftLim);
    end

end


