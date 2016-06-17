function [ downDic ] = downSampleDic( dic, factor )

downDic = zeros(size(dic, 1)/factor, size(dic, 2));

for i = 1:size(downDic, 1)
    downDic(i,:) = mean(dic(((i-1)*factor + 1):(i*factor), :));
end

end

