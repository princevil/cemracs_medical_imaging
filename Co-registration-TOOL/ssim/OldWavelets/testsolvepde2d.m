

base=start(3,6);
J0=base.J0;

grid=uniform2d(J0,6);


alpha=0.001;
mass=operator2d(grid,grid,[1 0 0; 0 0 0; 0 0 0],base);
stiff=operator2d(grid,grid,[0 1 -alpha; 1 0 0; -alpha 0 0],base);

ndof=grid.npoints;

f=ones(ndof,1);

[stiff,f]=appendbc2d(stiff,mass,f,grid);

v=stiff\f;

y=mass*v;

plot2d(y,grid);


