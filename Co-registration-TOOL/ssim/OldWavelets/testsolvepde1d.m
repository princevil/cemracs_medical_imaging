global a THETA J L P J0

start(3,6);

grid=uniform1d(J0,6);

mass=operator(grid,[1 0 0]);
stiff=operator(grid,[0 3 -0.001]);

[ndof,junk]=size(grid);

f=ones(ndof,1);

[x,I]=sort(grid(:,3));

[stiff,f]=appendbc(stiff,mass,f,grid);

v=stiff\f;

y=mass*v;

plot(x,y(I));


