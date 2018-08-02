function spazio=uniformspace1d(j0,jmax)
spazio.nfun = 2^jmax;
spazio.j = jmax*ones(spazio.nfun,1);
spazio.k = (0:2^jmax-1)';
spazio.type = zeros(spazio.nfun,1);
