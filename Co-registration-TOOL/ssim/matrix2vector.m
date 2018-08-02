function v = matrix2vector(M,L)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

v = zeros(size(L,1)*size(L,2),1);

for i = 1:size(L,2)
    v(L(:,i))=M(:,i);
end

end

