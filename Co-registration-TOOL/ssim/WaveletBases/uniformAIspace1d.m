function spazio=uniformAIspace1d(j0,D)

npoints=2^j0+2*D;
spazio.j=j0*ones(npoints,1);
spazio.k=(-D:2^j0+D-1);
spazio.nfun=npoints;


