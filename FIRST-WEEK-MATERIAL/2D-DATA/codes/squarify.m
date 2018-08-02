function [SQ_pict] = squarify(pict)

% exaggerate saturation if necessary
%  pict(find(pict < 125)) = 0;
%  pict(find(pict  > 126)) = 1;

% squarify

  [I,J] = size(pict);
M = max(I,J);
m = min(I,J);
D = M - m;

sq_pict = zeros(M,M);

sq_pict( (1 + floor(D*(I==m)/2)):(end - floor(D*(I==m)/2)) , (1 + floor(D*(J==m)/2)):(end - floor(D*(J==m)/2)) ) = pict;

% make the edge length the smallest possible power of two

j = ceil(log2(M));

SQ_pict = zeros(2^j,2^j);

SQ_pict( (1 + floor((2^j - M)/2)):(end - floor((2^j) - M)/2) , (1 + floor((2^j - M)/2)):(end - floor((2^j) - M)/2) ) = sq_pict;




end
