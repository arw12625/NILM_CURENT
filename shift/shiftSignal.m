function shifted = shiftSignal(sig, amount)
    len = length(sig);
    shifted = zeros(len, 1);
    if amount <= len
            startInd = len - amount + 1;
            endInd = amount;
            shifted(1:endInd) = sig(startInd:end);
    else
            startInd = amount - len + 1;
            endInd = 2*len - amount;
            shifted(startInd:end) = sig(1:endInd);
    end

end

