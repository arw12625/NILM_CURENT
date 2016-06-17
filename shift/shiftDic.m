function [ shifted ] = shiftDic( dictionary, num )

len = size(dictionary, 1);
width = size(dictionary, 2);

shifted = zeros(len, 1+(2*num) * width);

for i = 1 : num
   shifted(1:len - i, 1+(i-1)*width:i*width) = dictionary(i+1:len,:);
end
shifted(:, num*width+1: (1+num)*width) = dictionary;
for i = 1 : num
   shifted(i+1:len, 1+(num+1+i-1)*width:(num+1+i)*width) = dictionary(1:len - i,:);
end

end

