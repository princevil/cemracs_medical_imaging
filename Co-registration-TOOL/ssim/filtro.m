function h=filtro(a)
nw=max(size(a)); L=2*nw-1;
h=zeros(2*L+1,1);
h(L+1)=1;
h(L+2:2:2*L+1)=a;
h(L:-2:1)=a;