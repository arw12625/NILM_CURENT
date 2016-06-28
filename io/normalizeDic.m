%normalize the columns of a dictionary and return the magnitudes
function [ dictionary, mag ] = normalizeDic( indic, varargin)

threshold = 0;
switch nargin - 1 
    case 1
        threshold = cell2mat(varargin(1));
    case 0
        threshold = realmin;
    otherwise
        error('wrong number of args for normalizeDic');
end


mag = sqrt(sum(indic.^2, 1));

indices = abs(mag) > threshold;

dictionary = zeros(size(indic));
dictionary(:,indices) = bsxfun(@rdivide, indic(:, indices), mag(:, indices));


end

