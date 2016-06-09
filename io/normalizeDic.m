%normalize the columns of a dictionary and return the magnitudes
function [ dictionary, mag ] = normalizeDic( indic, varargin)

threshold = 0;
switch nargin - 1 
    case 1
        threshold = varargin(1);
    case 0
        threshold = 0.1;
    otherwise
        error('wrong number of args for normalizeDic');
end


mag = sqrt(sum(indic.^2, 1));

nonzero = abs(mag) > threshold;

dictionary = zeros(size(indic));
dictionary(:,nonzero) = bsxfun(@rdivide, indic(:, nonzero), mag(:, nonzero));


end

