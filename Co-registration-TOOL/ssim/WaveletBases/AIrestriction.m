function [pointer,pattern]=AIrestriction(m,k,points,N,D)
pointer = 2^N*(2.^(m-points(:,1)).*points(:,2)-k);
pattern = logical((-D*2^N<pointer)&(pointer<(D+1)*2^N));
pointer = pointer+D*2^N+1;
pointer = pointer(pattern);