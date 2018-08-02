function [refined_contour] = smooth3(cont, epsilon)

% refines by deleting midpoint of almost straight chains of adjacent points

  spotted = 1;
while spotted ==1
  spotted = 0;

  N1 = componentwise_norm(cont - cyclic_permutation(cont,2));
  N2 = componentwise_norm(cont - cyclic_permutation(cont,1));
  N3 = componentwise_norm(cyclic_permutation(cont,1) - cyclic_permutation(cont,2));

  positions = find( abs(N1 - N2 - N3) < epsilon );
  cont(:,positions) = [];
  refined_contour = cont;

  spotted = length(positions) == 0;
end

end
