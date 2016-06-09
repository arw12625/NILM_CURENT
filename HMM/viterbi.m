
function [X] = viterbi(S,P,Y,A,B)

T = length(Y);
T1 = zeros(S, T);
T2 = zeros(S, T);

for i = 1:S
T1(i,1)=P(i)*B(i,Y(1));
end

for i = 2:T
for j = 1:S
[T1(j,i),T2(j,i)] = max(T1(:,i-1).*A(:,j).*B(j,Y(i)));
end
end

Z = zeros(1,T);
X = zeros(1,T);

[~, Z(T)]=max(T1(:,T));
X(T)=Z(T);

for index = 2:T
i = T+2-index;
Z(i-1)=T2(Z(i), i);
X(i-1)=Z(i-1);
end

end

