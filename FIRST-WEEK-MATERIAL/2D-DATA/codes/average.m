function [averaged_cont] = average(cont,h)

  spotted = 1;

while spotted == 1

  spotted = 0;

  npoints = size(cont,2);
  D = componentwise_norm(cont - cyclic_permutation(cont,1));
  positions = find(D<h);
  cont(:,positions) = ( cont(:,positions) + cont(:,mod(positions+1,npoints)+1) )/2;
  cont(:,mod(positions+1,npoints)+1) = [];

  spotted = 1 - (length(positions) == 0);

end

averaged_cont = cont;

end
