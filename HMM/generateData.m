
function [data] = generateData(steadyTimes, steadyStates)
size = sum(steadyTimes);
data = zeros(1,size);
j=0;
k=0;
for i = 1:size
    if k<=0
        j=j+1;
        k=steadyTimes(j);
    end
    data(i)=steadyStates(j);
    k = k -1;
end