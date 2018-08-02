function [array_permuted] = cyclic_permutation(array,order)

% cyclicly permutes a "horizontal" array

  array_permuted = 0*array;
array_permuted(:,1:order) = array(:,end-order+1:end);
    array_permuted(:,order+1:end) = array(:,1:end-order);

end
