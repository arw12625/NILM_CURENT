function [ base ] = addShifted( base, toAdd, mult, shift, shiftLim )

len = length(base);

if shift <= shiftLim + 1
    startInd = shiftLim - shift + 2;
    endInd = len + shift - shiftLim - 1;
    base(1:endInd) = base(1:endInd) + mult * toAdd(startInd:end);
else
    startInd = shift - shiftLim;
    endInd = len - shift + shiftLim + 1;
    base(startInd:end) = base(startInd:end) + mult* toAdd(1:endInd);
end


end

