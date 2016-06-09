%normalize signal and return signal and magnitude

function [ signal, mag ] = normalize( insignal )

mag = sqrt(sum(insignal.^2));
signal = insignal / mag;


end

