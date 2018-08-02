function spazio=uniformAIspace2d(j0,D)

npoints=(2^j0+2*D)^2;
spazio.j=zeros(npoints,1);
spazio.kx=zeros(npoints,1);
spazio.ky=zeros(npoints,1);
spazio.nfun=npoints;

v=(-D:2^j0+D-1);
ky=repmat(v,2^j0+2*D,1); ky=reshape(ky,(2^j0+2*D)^2,1);
kx=repmat(v',1,2^j0+2*D);
kx=reshape(kx,(2^j0+2*D)^2,1);

spazio.j=j0*ones(npoints,1);
spazio.kx=kx;
spazio.ky=ky;

