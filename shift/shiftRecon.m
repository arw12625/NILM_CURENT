function sig = shiftRecon(dic, x)
    sig = zeros(size(dic, 1), 1);
    len = size(dic, 1);
    [shift, signal, val] = find(x);
    for i = 1:length(shift)
        if shift(i) <= len
            startInd = len - shift(i) + 1;
            endInd = shift(i);
            sig(1:endInd) = sig(1:endInd) + val(i) * dic(startInd:end, signal(i));
        else
            startInd = shift(i) - len + 1;
            endInd = 2*len - shift(i);
            sig(startInd:end) = sig(startInd:end) + val(i) * dic(1:endInd, signal(i));
        end
    end

end


